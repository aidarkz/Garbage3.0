#!/bin/sh
set -e

# Запускаем HLS Proxy
/opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080 &

# Пингер в фоне
/selfping.sh &

# Ждём завершения
wait
