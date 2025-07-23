#!/bin/bash
set -e

PROXY_BIN="/opt/hlsp/hls-proxy"
PROXY_ARGS="-address 0.0.0.0:8080"
HEALTH_LOCAL_URL="http://127.0.0.1:8080/channel/n58c5b493/index.m3u8?q=1753280172771"
CHECK_INTERVAL=60

log() {
  echo "[start.sh] $(date '+%Y-%m-%d %H:%M:%S') $*"
}

# запустить hls-proxy в фоне
run_proxy() {
  log "▶️ Запуск hls-proxy..."
  $PROXY_BIN $PROXY_ARGS &
  PROXY_PID=$!
  log "🆔 PID hls-proxy: $PROXY_PID"
}

keepalive_loop() {
  sleep 5
  while true; do
    sleep $CHECK_INTERVAL
    if curl -fs "$HEALTH_LOCAL_URL" >/dev/null; then
      log "📡 Прокси жив (localhost)"
    else
      log "⚠️ Нет ответа от прокси. Пробуем перезапуск..."
      kill -9 $PROXY_PID 2>/dev/null || true
      run_proxy
    fi
  done
}

log "🚀 Старт Keep-Alive loop и hls-proxy..."
run_proxy
keepalive_loop
