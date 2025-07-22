#!/bin/bash

set -e

PROXY_BIN="/opt/hlsp/hls-proxy"
PROXY_ARGS="-address 0.0.0.0"
HEALTH_URL="http://lxuwvqoc.deploy.cx/health"
CHECK_INTERVAL=60

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

start_proxy() {
  log "🔄 Starting hls-proxy..."
  $PROXY_BIN $PROXY_ARGS &
  PROXY_PID=$!
  log "✅ hls-proxy started with PID $PROXY_PID"
}

kill_proxy() {
  if kill -0 "$PROXY_PID" 2>/dev/null; then
    log "🛑 Killing hls-proxy with PID $PROXY_PID..."
    kill "$PROXY_PID"
    wait "$PROXY_PID" 2>/dev/null || true
  fi
}

trap 'log "🚨 Caught SIGTERM. Shutting down..."; kill_proxy; exit 0' SIGTERM

log "🚀 Entrypoint started"

start_proxy

while true; do
  sleep $CHECK_INTERVAL

  if curl -fs "$HEALTH_URL" >/dev/null; then
    log "✅ Health check passed"
  else
    log "❌ Health check failed, restarting proxy"
    kill_proxy
    start_proxy
  fi
done
