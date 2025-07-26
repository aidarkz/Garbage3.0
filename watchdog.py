import subprocess
import time
import os
import signal

TARGET = "stalker_hls_proxy.py"
RESTART_DELAY = 180  # 3 минуты

def is_process_running(name):
    try:
        output = subprocess.check_output(['ps', 'aux'], text=True)
        return any(name in line and 'python' in line for line in output.splitlines())
    except Exception as e:
        print(f"[watchdog] Error checking process: {e}")
        return False

def restart_process():
    print(f"[watchdog] Restarting {TARGET}")
    try:
        os.killpg(0, signal.SIGTERM)
    except Exception as e:
        print(f"[watchdog] Failed to terminate: {e}")
    subprocess.Popen(['python3', f'/app/{TARGET}'])

if __name__ == "__main__":
    while True:
        if not is_process_running(TARGET):
            print(f"[watchdog] Process {TARGET} not running, restarting...")
            restart_process()
        time.sleep(RESTART_DELAY)
