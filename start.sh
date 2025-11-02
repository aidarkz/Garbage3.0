#!/bin/bash
set -e

echo "=== Starting HLS Proxy ==="

# Создаём директории
mkdir -p /opt/hlsp/cache

# default.json — ЯВНО порт 8080 и 127.0.0.1
if [ ! -f /opt/hlsp/default.json ]; then
  cat > /opt/hlsp/default.json << 'EOF'
{
  "port": 8080,
  "address": "127.0.0.1",
  "save": true,
  "cache": true,
  "logLevel": "info"
}
EOF
fi

# groups.json
[ ! -f /opt/hlsp/groups.json ] && echo '[]' > /opt/hlsp/groups.json

# local.json
[ ! -f /opt/hlsp/local.json ] && cat > /opt/hlsp/local.json << 'EOF'
{
  "groups": [],
  "plugins": [
    "plugins/m3u8.js",
    "plugins/removeUserAgent.m3u8.js"
  ],
  "cacheDir": "cache",
  "maxCacheSize": 1073741824,
  "segmentTimeout": 30,
  "playlistTimeout": 30
}
EOF

# Запуск nginx
echo "Starting nginx on port 80..."
nginx -g 'daemon off;' &

# Запуск hls-proxy на 127.0.0.1:8080
echo "Starting hls-proxy on 127.0.0.1:8080..."
exec /opt/hlsp/hls-proxy
