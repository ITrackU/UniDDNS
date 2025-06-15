#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

# Create a .env file if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
  cat > "$ENV_FILE" <<EOF
# Copy your Gandi API key and domain here
GANDI_API_KEY=your_api_key_here
DOMAIN=yourdomain.tld
EOF
  echo ".env file created at $ENV_FILE. Please edit it with your API key and domain."
else
  echo ".env file already exists at $ENV_FILE."
fi

# Create log file with proper permissions if it doesn't exist
LOG_FILE="/var/log/gandi_ddns.log"
if [ ! -f "$LOG_FILE" ]; then
  sudo touch "$LOG_FILE"
  sudo chmod 644 "$LOG_FILE"
  echo "Log file created at $LOG_FILE with permissions 644."
else
  echo "Log file already exists at $LOG_FILE."
fi

# Create temp directory for local files if it doesn't exist
LOCAL_DIR="/tmp/gandi_ddns"
mkdir -p "$LOCAL_DIR"
chmod 700 "$LOCAL_DIR"

echo "Setup complete. Remember to edit your .env file before running the script."
