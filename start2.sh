#!/bin/bash
echo "[start.sh] Старт supervisor и cron"
service cron start
supervisord -c /etc/supervisor/conf.d/supervisor.conf
tail -f /dev/null
