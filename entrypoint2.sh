#!/bin/bash

# Запускаем HLS Proxy в фоне
/opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080 &
HLS_PID=$!

# Пингуем локально, чтобы прокси не заснул
/opt/selfping.sh &

# Ждём завершения основного процесса
wait $HLS_PID
