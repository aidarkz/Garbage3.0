#!/usr/bin/env python3
import time
import logging
import requests

PING_URL = "https://uhnauyno.deploy.cx/status"
LOG_FILE = "/app/logs/keepalive-cron.log"
INTERVAL = 30  # сек

# ──────────────────────── Логирование ────────────────────────
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="[%(asctime)s] %(levelname).1s %(message)s",
)

# ──────────────────────── Keepalive цикл ────────────────────────
def main():
    while True:
        try:
            logging.info("🟢 keepalive-cron запущен.")
            r = requests.get(PING_URL, timeout=5)
            if r.status_code == 200:
                logging.info("✅ ping %s → %s", PING_URL, r.status_code)
            else:
                logging.warning("⚠️ ping %s → %s", PING_URL, r.status_code)
        except Exception as e:
            logging.warning("🔌 ошибка ping %s → %s", PING_URL, str(e))
        time.sleep(INTERVAL)

if __name__ == "__main__":
    main()
