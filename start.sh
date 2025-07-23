#!/bin/bash
set -e

PROXY_BIN="/opt/hlsp/hls-proxy"
PROXY_ARGS="-address 0.0.0.0:8080"
HEALTH_LOCAL_URL="http://127.0.0.1:8080/n58c5b493/index.m3u8?q=1753280172771"
CHECK_INTERVAL=60

log() {
  echo "[start.sh] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

keepalive_loop() {
  sleep 5
  while true; do
    sleep $CHECK_INTERVAL
    curl -fs "$HEALTH_URL" >/dev/null \
      && log "📡 Прокси жив (localhost)" \
      || log "⚠️ Нет ответа от прокси на localhost"
  done
}

log "🚀 Старт Keep-Alive loop..."
keepalive_loop &

log "▶️ Запуск hls-proxy как основной процесс..."
exec $PROXY_BIN $PROXY_ARGS
