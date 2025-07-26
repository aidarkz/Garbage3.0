import time
import http.client
import os
from datetime import datetime

LOG_DIR = "/app/logs"
LOG_FILE = f"{LOG_DIR}/keepalive.log"
INTERVAL = 20  # секунд

os.makedirs(LOG_DIR, exist_ok=True)

def log(msg):
    with open(LOG_FILE, "a") as f:
        f.write(f"[{datetime.now().isoformat()}] {msg}\n")

def get_mem_usage():
    try:
        with open("/sys/fs/cgroup/memory.current") as f:
            return int(f.read().strip())
    except Exception as e:
        log(f"Ошибка чтения памяти: {e}")
        return 0

def get_cpu_usage():
    try:
        with open("/sys/fs/cgroup/cpu.stat") as f:
            for line in f:
                if line.startswith("usage_usec"):
                    return int(line.split()[1])
    except Exception as e:
        log(f"Ошибка чтения CPU: {e}")
        return 0

def ping_local_api():
    try:
        conn = http.client.HTTPConnection("127.0.0.1", 80, timeout=3)
        conn.request("GET", "/health")
        resp = conn.getresponse()
        return resp.status == 200
    except Exception as e:
        log(f"❌ Пинг /health не прошёл: {e}")
        return False

def ping_external():
    try:
        conn = http.client.HTTPConnection("1.1.1.1", 80, timeout=3)
        conn.request("HEAD", "/")
        return True
    except Exception as e:
        log(f"❌ Внешний пинг не прошёл: {e}")
        return False

while True:
    ts = int(time.time())
    mem = get_mem_usage()
    cpu = get_cpu_usage()
    ok_api = ping_local_api()
    ok_net = ping_external()

    log(f"HLS-PROXY: {'✅' if ok_net else '❌'} | API: {'✅' if ok_api else '❌'} | ts={ts} | mem={mem} | cpu={cpu}")
    time.sleep(INTERVAL)
