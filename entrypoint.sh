#!/usr/bin/env bash
set -euo pipefail

# Defaults
UUID_VAL="${UUID:-139256ab-37c7-412f-9e46-0d0495fefc9f}"
WSPATH_VAL="${WSPATH:-/vless}"
PORT_VAL="${PORT:-8080}"

# Generate config to /etc/v2ray/config.json
mkdir -p /etc/v2ray
cat > /etc/v2ray/config.json <<EOF
{
  "inbounds": [
    {
      "port": ${PORT_VAL},
      "protocol": "vless",
      "settings": {
        "clients": [
          { "id": "${UUID_VAL}" }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WSPATH_VAL}" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF

# Start v2ray
exec /usr/bin/v2ray run -c /etc/v2ray/config.json
