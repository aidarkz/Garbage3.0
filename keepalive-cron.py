import time
import logging
import sys
import requests

CHECK_URL = "http://127.0.0.1:8282/status"  # локальный URL
INTERVAL_SECONDS = 30
LOG_FILE = "/app/logs/keepalive-cron.log"

logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="[%(asctime)s] %(levelname).1s %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

HEADERS = {
    "X-Pass": "admin"
}

def ping_local():
    try:
        resp = requests.get(CHECK_URL, headers=HEADERS, timeout=5)
        if resp.status_code == 200:
            logging.info(f"🟢 local OK: {CHECK_URL}")
            return True
        else:
            logging.warning(f"⚠️ local {CHECK_URL} → {resp.status_code}")
            return False
    except Exception as e:
        logging.warning(f"❌ local error: {e}")
        return False

if __name__ == "__main__":
    while True:
        if not ping_local():
            logging.error("🛑 Перезапуск контейнера, т.к. local недоступен")
            sys.exit(1)
        time.sleep(INTERVAL_SECONDS)
