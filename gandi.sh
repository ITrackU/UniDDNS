#!/bin/bash
set -euo pipefail
trap 'echo "Error on line $LINENO" >&2' ERR

# Load configuration from .env file
ENV_FILE="$(dirname "$0")/.env"
if [ -f "$ENV_FILE" ]; then
    export $(grep -v '^#' "$ENV_FILE" | xargs)
else
    echo "Missing .env file at $ENV_FILE"
    exit 1
fi

# Validate required variables
if [ -z "${GANDI_API_KEY:-}" ] || [ -z "${DOMAIN:-}" ]; then
    echo "GANDI_API_KEY and DOMAIN must be set in the .env file."
    exit 1
fi

# Configuration
ROOT_SUBDOMAIN="@"              # Root domain
WILDCARD_SUBDOMAIN="*"          # Wildcard domain
LOCAL_DIR="/tmp/gandi_ddns"
LOG_FILE="/var/log/gandi_ddns.log"

# Create local dir
mkdir -p "$LOCAL_DIR"

# File paths for tracking last IPs
LAST_ROOT_IP_FILE="$LOCAL_DIR/last_root_ip.txt"
LAST_WILDCARD_IP_FILE="$LOCAL_DIR/last_wildcard_ip.txt"

# Logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Get current public IP
get_current_ip() {
    IP=$(curl -s https://api.ipify.org)
    if [ -z "$IP" ]; then
        IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
    fi
    echo "$IP"
}

# Update Gandi DNS record
update_gandi_dns() {
    local SUBDOMAIN=$1
    local NEW_IP=$2
    local TTL=$3

    RESPONSE=$(curl -s -X PUT \
        -H "Authorization: Apikey $GANDI_API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"rrset_ttl\": $TTL, \"rrset_values\": [\"$NEW_IP\"]}" \
        "https://api.gandi.net/v5/livedns/domains/$DOMAIN/records/$SUBDOMAIN/A")

    if echo "$RESPONSE" | grep -q "error"; then
        log "ERROR updating $SUBDOMAIN.$DOMAIN -> $NEW_IP: $RESPONSE"
    else
        log "Updated $SUBDOMAIN.$DOMAIN to $NEW_IP (TTL $TTL)"
    fi
}

# Check and update IP if it changed
check_and_update() {
    local SUBDOMAIN=$1
    local TTL=$2
    local IP_FILE=$3

    CURRENT_IP=$(get_current_ip)

    if [ ! -f "$IP_FILE" ] || [ "$(cat "$IP_FILE")" != "$CURRENT_IP" ]; then
        echo "$CURRENT_IP" > "$IP_FILE"
        log "IP for $SUBDOMAIN changed to $CURRENT_IP"
        update_gandi_dns "$SUBDOMAIN" "$CURRENT_IP" "$TTL"
    else
        log "No IP change for $SUBDOMAIN.$DOMAIN"
    fi
}

# Main
main() {
    check_and_update "$ROOT_SUBDOMAIN" 300 "$LAST_ROOT_IP_FILE"
    check_and_update "$WILDCARD_SUBDOMAIN" 10800 "$LAST_WILDCARD_IP_FILE"
}

main
