import time
import http.client
from datetime import datetime

LOG_FILE = "/app/keepalive-cron.log"
INTERVAL = 20  # seconds

def log(msg):
    with open(LOG_FILE, "a") as f:
        f.write(f"[{datetime.now().isoformat()}] {msg}\n")

def get_mem_usage():
    try:
        with open("/sys/fs/cgroup/memory.current") as f:
            return int(f.read().strip())
    except:
        return 0

def get_cpu_usage():
    try:
        with open("/sys/fs/cgroup/cpu.stat") as f:
            for line in f:
                if line.startswith("usage_usec"):
                    return int(line.split()[1])
    except:
        return 0

def ping_local_health():
    try:
        conn = http.client.HTTPConnection("127.0.0.1", 80, timeout=3)
        conn.request("GET", "/health")
        resp = conn.getresponse()
        conn.close()
        return resp.status == 200
    except Exception as e:
        log(f"[ping_local_health] ERROR: {e}")
        return False

def fake_curl_like_traffic():
    try:
        conn = http.client.HTTPConnection("127.0.0.1", 80, timeout=3)
        conn.request("HEAD", "/health")
        resp = conn.getresponse()
        conn.close()
        return resp.status == 200
    except Exception as e:
        log(f"[fake_curl] ERROR: {e}")
        return False

def ping_external_net():
    try:
        conn = http.client.HTTPConnection("1.1.1.1", 80, timeout=3)
        conn.request("HEAD", "/")
        resp = conn.getresponse()
        conn.close()
        return True
    except:
        return False

while True:
    ts = int(time.time())
    mem = get_mem_usage()
    cpu = get_cpu_usage()

    ok_api = ping_local_health()
    ok_fake = fake_curl_like_traffic()
    ok_net = ping_external_net()

    log(f"HLS-PROXY: {'✅' if ok_net else '❌'} | API: {'✅' if ok_api else '❌'} | curl: {'✅' if ok_fake else '❌'} | ts={ts} | mem={mem} | cpu={cpu}")
    time.sleep(INTERVAL)
