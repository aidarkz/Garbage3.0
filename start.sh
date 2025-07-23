#!/bin/bash
set -e

# Стартуем nginx (если требуется)
service nginx start || true

# Ждём пару секунд (на всякий случай)
sleep 2

# Запускаем hls-proxy как основной процесс
exec /opt/hlsp/hls-proxy --config /opt/hlsp/config.json
