#!/bin/bash

set -e

PROXY_BIN="/opt/hlsp/hls-proxy"
PROXY_ARGS="-address 0.0.0.0:8080"
HEALTH_URL="http://127.0.0.1:8080/channel/101/index.m3u8"
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
