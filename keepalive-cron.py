import time
import logging
import sys
import requests

CHECK_URL = "http://egwufhlp.deploy.cx/status"
INTERVAL_SECONDS = 30

LOG_FILE = "/app/logs/keepalive-cron.log"
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="[%(asctime)s] %(levelname).1s %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

def ping_remote():
    try:
        resp = requests.get(CHECK_URL, timeout=5)
        if resp.status_code == 200:
            logging.info(f"🟢 remote OK: {CHECK_URL}")
            return True
        else:
            logging.warning(f"⚠️ remote {CHECK_URL} → {resp.status_code}")
            return False
    except Exception as e:
        logging.warning(f"❌ remote error: {e}")
        return False

if __name__ == "__main__":
    while True:
        if not ping_remote():
            logging.error("🛑 Перезапуск контейнера, т.к. remote недоступен")
            sys.exit(1)
        time.sleep(INTERVAL_SECONDS)
