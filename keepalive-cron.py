import time
import http.client
import requests
import subprocess
from datetime import datetime

LOG_FILE = "/app/logs/keepalive-cron.log"
INTERVAL = 60  # seconds
STREAM_URL = "http://127.0.0.1:8080/playlist1.m3u8?stream_id=111542"

def log(msg):
    with open(LOG_FILE, "a") as f:
        f.write(f"[KEEPALIVE] {datetime.now().isoformat()} {msg}\n")

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

def ping_local_api():
    try:
        conn = http.client.HTTPConnection("127.0.0.1", 8080, timeout=3)
        conn.request("GET", "/ping")
        resp = conn.getresponse()
        return resp.status == 200
    except Exception as e:
        return False

def ping_external():
    try:
        conn = http.client.HTTPConnection("1.1.1.1", 80, timeout=3)
        conn.request("HEAD", "/")
        return True
    except:
        return False

def ping_stream():
    try:
        r = requests.get(STREAM_URL, timeout=3)
        return r.status_code == 200
    except:
        return False

def log_system_info():
    try:
        uptime = subprocess.check_output(["uptime"]).decode().strip()
        ps_output = subprocess.check_output(["ps", "aux"]).decode()
        netstat_output = subprocess.check_output(["netstat", "-tunlp"]).decode()
        log(f"\n--- SYSTEM INFO ---\nUptime: {uptime}\n\n[PS AUX]\n{ps_output}\n[NETSTAT]\n{netstat_output}")
    except Exception as e:
        log(f"[ERROR] Failed to log system info: {e}")

counter = 0
while True:
    ts = int(time.time())
    mem = get_mem_usage()
    cpu = get_cpu_usage()
    ok_api = ping_local_api()
    ok_net = ping_external()
    ok_stream = ping_stream()

    log(f"NET: {'✅' if ok_net else '❌'} | API: {'✅' if ok_api else '❌'} | STREAM: {'✅' if ok_stream else '❌'} | ts={ts} | mem={mem} | cpu={cpu}")

    if counter % 15 == 0:  # каждые 5 минут (20 сек * 15)
        log_system_info()

    counter += 1
    time.sleep(INTERVAL)
