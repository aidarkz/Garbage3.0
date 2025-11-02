#!/bin/bash
set -e

echo "=== Starting HLS Proxy ==="

# === Создаём конфиги, если их нет ===
mkdir -p /opt/hlsp/cache

if [ ! -f /opt/hlsp/default.json ]; then
  cat > /opt/hlsp/default.json << 'EOF'
{
  "port": 8080,
  "save": true,
  "cache": true,
  "logLevel": "info"
}
EOF
fi

if [ ! -f /opt/hlsp/groups.json ]; then
  echo '[]' > /opt/hlsp/groups.json
fi

if [ ! -f /opt/hlsp/local.json ]; then
  cat > /opt/hlsp/local.json << 'EOF'
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
fi

# === Запуск nginx в фоне (foreground mode) ===
echo "Starting nginx..."
nginx -g 'daemon off;' &
NGINX_PID=$!

# === Запуск hls-proxy как PID 1 (через exec) ===
echo "Starting hls-proxy on 0.0.0.0:8080..."
exec /opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 -save
