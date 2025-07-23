#!/bin/bash
service nginx start

# Keep-alive loop (опционально, но желательно)
while true; do
    curl -s http://127.0.0.1:8080/health > /dev/null
    sleep 60
done &

exec /opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080
