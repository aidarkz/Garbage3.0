#!/bin/bash

# Запуск nginx
nginx

# Запуск hls-proxy
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 &

# Лог hls-proxy (если он пишет в stdout или в лог-файл — подставь путь)
/bin/bash -c "while true; do ps aux | grep hls-proxy | grep -v grep; sleep 10; done"
