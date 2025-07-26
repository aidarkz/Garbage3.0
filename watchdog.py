import asyncio
import subprocess
import time
import os
import signal
from aiohttp import web

TARGET = "stalker_hls_proxy.py"
RESTART_DELAY = 180  # 3 минуты
LOG = "/app/logs/watchdog.log"

def log(msg):
    with open(LOG, "a") as f:
        f.write(f"[watchdog] {time.strftime('%Y-%m-%d %H:%M:%S')} {msg}\n")

def is_process_running(name):
    try:
        output = subprocess.check_output(['ps', 'aux'], text=True)
        return any(name in line and 'python' in line for line in output.splitlines())
    except Exception as e:
        log(f"Error checking process: {e}")
        return False

def restart_process():
    log(f"Restarting {TARGET}")
    try:
        os.killpg(0, signal.SIGTERM)
    except Exception as e:
        log(f"Failed to terminate: {e}")
    subprocess.Popen(['python3', f'/app/{TARGET}'])

async def watchdog_loop():
    while True:
        if not is_process_running(TARGET):
            log(f"Process {TARGET} not running, restarting...")
            restart_process()
        await asyncio.sleep(RESTART_DELAY)

# AIOHTTP server
async def handle_ping(request):
    return web.Response(text="✅ Watchdog is alive")

async def main():
    app = web.Application()
    app.add_routes([web.get('/watchdog', handle_ping)])

    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, '0.0.0.0', 5050)
    await site.start()

    await watchdog_loop()

if __name__ == "__main__":
    asyncio.run(main())
