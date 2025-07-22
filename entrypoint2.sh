#!/bin/bash
set -e

APP_BIN="/opt/hlsp/hls-proxy"
HEALTH_URL="http://lxuwvqoc.deploy.cx/health"
LOG_FILE="/var/log/proxy_watchdog.log"

function log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

function start_proxy() {
    log "🔄 Starting hls-proxy..."
    "$APP_BIN" &
    PROXY_PID=$!
    log "✅ hls-proxy started with PID $PROXY_PID"
}

function stop_proxy() {
    if [ -n "$PROXY_PID" ]; then
        log "🛑 Stopping hls-proxy (PID $PROXY_PID)..."
        kill "$PROXY_PID" 2>/dev/null || true
        wait "$PROXY_PID" 2>/dev/null || true
        PROXY_PID=""
    fi
}

function health_check() {
    curl -s --max-time 5 "$HEALTH_URL" | grep -q '"status": *"ok"'
    return $?
}

log "🚀 Entrypoint started"

start_proxy

# Вечный цикл наблюдения
while true; do
    sleep 60

    if ! ps -p "$PROXY_PID" > /dev/null; then
        log "⚠️ hls-proxy is not running!"
        stop_proxy
        start_proxy
        continue
    fi

    if ! health_check; then
        log "❌ Health check failed. Restarting hls-proxy..."
        stop_proxy
        start_proxy
    else
        log "✅ Health check passed"
    fi
done
