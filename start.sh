#!/bin/bash

set -e

PROXY_BIN="/opt/hlsp/hls-proxy"
PROXY_ARGS="-address 0.0.0.0:8080"
HEALTH_URL="https://uhnauyno.deploy.cx/channel/n58c5b493/index.m3u8?q=1753280172771"
CHECK_INTERVAL=60

log() {
  echo "[start.sh] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

# 🎯 Фоновый watchdog, НЕ главный процесс!
watchdog_loop() {
  sleep 10
  while true; do
    sleep $CHECK_INTERVAL
    if curl -fs "$HEALTH_URL" >/dev/null; then
      log "✅ Канал отвечает OK"
    else
      log "❌ Канал не отвечает! (no /channel/101)"
    fi
  done
}

log "🚀 Старт watchdog в фоне..."
watchdog_loop &

log "▶️ Запуск hls-proxy как главный процесс..."
exec $PROXY_BIN $PROXY_ARGS
