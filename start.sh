#!/bin/bash
set -e

# Запускаем hls-proxy в фоне (без -quit!)
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 -save &
HLS_PID=$!

# Запускаем nginx в foreground (важно: -g 'daemon off;')
nginx -g 'daemon off;'

# Если nginx упадёт — убьём hls-proxy
kill $HLS_PID
