#!/bin/bash
set -e

echo "=== Starting HLS Proxy ==="

# === Создаём конфиги, если их нет ===

# default.json
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

# groups.json
if [ ! -f /opt/hlsp/groups.json ]; then
  echo '[]' > /opt/hlsp/groups.json
fi

# local.json — ГЛАВНЫЙ КОНФИГ
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

# === Запуск ===
echo "Starting hls-proxy..."
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 -save &
HLS_PID=$!

sleep 5

if ! kill -0 $HLS_PID 2>/dev/null; then
  echo "ERROR: hls-proxy failed to start!"
  cat /opt/hlsp/*.log 2>/dev/null || true
  exit 1
fi

echo "hls-proxy started successfully"
echo "Starting nginx..."
exec nginx -g 'daemon off;'
