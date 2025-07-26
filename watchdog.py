# watchdog.py
import subprocess
import time
import logging

logging.basicConfig(level=logging.INFO, format="[WATCHDOG] %(asctime)s %(message)s")

INTERVAL = 300  # раз в 5 минут (можно увеличить до 10-15 мин)

while True:
    logging.info("Restarting keepalive-cron via supervisorctl...")
    try:
        subprocess.run(["supervisorctl", "restart", "keepalive"], check=True)
    except Exception as e:
        logging.error(f"Restart failed: {e}")
    time.sleep(INTERVAL)
