#!/bin/bash

# Стартуем nginx в фоне
service nginx start

# Ждём пару секунд (иногда nginx может не успеть подняться)
sleep 2

# Стартуем hls-proxy как основной процесс (без &!)
exec /opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080
