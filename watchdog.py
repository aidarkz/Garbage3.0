import os
import time
import signal

TARGET = "main.py"
CHECK_INTERVAL = 10

def is_main_running():
    try:
        output = os.popen("ps aux").read()
        return TARGET in output
    except Exception:
        return False

def restart_main():
    os.system("pkill -f 'python3 /app/main.py'")

while True:
    if not is_main_running():
        restart_main()
    time.sleep(CHECK_INTERVAL)
