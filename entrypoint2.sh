#!/bin/sh

# Запуск selfping.sh в фоне
/selfping.sh &

# Запуск hls-proxy
exec ./hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080
