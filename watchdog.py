import os
import time
import signal
import subprocess

WATCHED_PROCESS_NAME = "main.py"
RESTART_INTERVAL = 180  # каждые 3 минуты

def get_pid_by_name(name):
    try:
        output = subprocess.check_output(["pgrep", "-f", name])
        pids = output.decode().strip().split("\n")
        return [int(pid) for pid in pids]
    except subprocess.CalledProcessError:
        return []

def restart_process(pid):
    try:
        print(f"[watchdog] Sending SIGTERM to PID {pid}")
        os.kill(pid, signal.SIGTERM)
    except Exception as e:
        print(f"[watchdog] Error killing PID {pid}: {e}")

while True:
    pids = get_pid_by_name(WATCHED_PROCESS_NAME)
    if pids:
        print(f"[watchdog] Found main.py at PIDs: {pids}")
        for pid in pids:
            restart_process(pid)
    else:
        print("[watchdog] main.py not found")
    time.sleep(RESTART_INTERVAL)
