import http.client
import logging
import time
import datetime
import socket
import requests

LOG_PATH = "/app/logs/keepalive-cron.log"
URL = "http://uhnauyno.deploy.cx/status"
INTERVAL = 60  # seconds

# ──────────────── Логирование ──────────────── #
logging.basicConfig(
    level=logging.INFO,
    format="[%(asctime)s] %(levelname).1s %(message)s",
    handlers=[
        logging.FileHandler(LOG_PATH),
        logging.StreamHandler()  # также выводим в stdout
    ]
)
log = logging.getLogger("keepalive-cron")

def is_online():
    """ Проверка наличия сети. """
    try:
        socket.create_connection(("8.8.8.8", 53), timeout=3)
        return True
    except OSError:
        return False

def ping_status_url():
    """ Пингует внешний сервис. """
    try:
        response = requests.get(URL, timeout=5)
        if response.status_code == 200:
            log.info(f"✅ ping {URL} → OK (200)")
            return True
        else:
            log.warning(f"⚠️ ping {URL} → {response.status_code}")
            return False
    except Exception as e:
        log.error(f"❌ Exception on ping {URL}: {e}")
        return False

def main():
    log.info("🟢 keepalive-cron запущен.")
    while True:
        now = datetime.datetime.now().isoformat()

        if not is_online():
            log.error("❌ Нет сетевого соединения (не пингуется 8.8.8.8)")
        else:
            ping_status_url()

        time.sleep(INTERVAL)

if __name__ == "__main__":
    main()
