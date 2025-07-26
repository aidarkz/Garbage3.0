#!/usr/bin/env python3
import logging
import http.client
import time
from urllib.parse import urlparse

URL = "https://uhnauyno.deploy.cx/status"
DELAY = 30  # секунд

logging.basicConfig(
    filename="/app/logs/keepalive-cron.log",
    level=logging.INFO,
    format="[%(asctime)s] %(levelname).1s %(message)s",
)

def ping(url):
    parsed = urlparse(url)
    host = parsed.hostname
    path = parsed.path or "/"
    port = parsed.port or (443 if parsed.scheme == "https" else 80)

    try:
        conn_class = http.client.HTTPSConnection if parsed.scheme == "https" else http.client.HTTPConnection
        conn = conn_class(host, port, timeout=10)
        headers = {
            "User-Agent": "Mozilla/5.0 (keepalive-cron)",
            "Accept": "*/*",
            "Connection": "close",
        }
        conn.request("GET", path, headers=headers)
        resp = conn.getresponse()
        conn.close()

        if 200 <= resp.status < 300:
            logging.info(f"🟢 keepalive-cron запущен. {resp.status=}")
        else:
            logging.warning(f"⚠️ ping {url} → {resp.status}")
    except Exception as e:
        logging.error(f"🔥 ошибка ping {url} → {type(e).__name__}: {e}")

if __name__ == "__main__":
    while True:
        ping(URL)
        time.sleep(DELAY)
