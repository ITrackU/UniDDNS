# Dynamic DNS Clients Collection

A collection of lightweight, flexible Dynamic DNS (DDNS) clients supporting multiple DNS providers — designed to keep your public IP updated automatically, especially useful for dynamic IP environments.

---

## Overview

This project provides scripts and tools to create DDNS clients for any DNS provider. The clients update DNS records when your public IP changes, enabling you to maintain consistent domain name resolution on Linux devices with dynamic IP addresses.

- Supports multiple languages: Bash, Python, etc.
- Easily adaptable to different DNS provider APIs
- Designed for portability across Linux systems
- Configurable via environment variables (`.env`) for security and flexibility
- Uses `/tmp` for temporary storage and `/var/log` for logging

---

## Features

- **Provider-agnostic:** Build clients for any DNS provider's API
- **Dynamic IP detection:** Automatically detects current public IP
- **Efficient updates:** Updates DNS records only on IP change
- **Secure configuration:** Stores API keys and domain info in environment variables
- **Simple deployment:** Easily installed with included install scripts
- **Extensible:** Add new DNS providers by customizing client scripts

---

## Getting Started

1. Clone this repository.
2. Select or create a client script for your DNS provider.
3. Configure your credentials and domain in the `.env` file.
4. Run the client manually or set it up as a scheduled job (cron or systemd).
5. Monitor logs in `/var/log` for update status.

---

## Example `.env`

```env
GANDI_API_KEY=your_api_key_here
DOMAIN=yourdomain.tld
```

---

## Usage

```bash
./install.sh        # Prepare environment and config
./gandi_ddns.sh     # Run the DDNS client
```

---

## Contributing

Contributions are welcome! Whether it's adding support for new DNS providers, fixing bugs, or improving documentation, feel free to open an issue or submit a pull request. Please ensure your changes are well-documented and tested.

---

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). See the `LICENSE` file for details.

