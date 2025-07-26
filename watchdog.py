import subprocess
import time
import os
import signal
import asyncio
from aiohttp import web

TARGET = "stalker_hls_proxy.py"
RESTART_DELAY = 180  # 3 минуты

async def healthcheck(request):
    return web.Response(text="watchdog OK")

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

async def monitor_loop():
    while True:
        if not is_process_running(TARGET):
            print(f"[watchdog] Process {TARGET} not running, restarting...")
            restart_process()
        await asyncio.sleep(RESTART_DELAY)

async def main():
    app = web.Application()
    app.add_routes([web.get("/ping", healthcheck)])
    runner = web.AppRunner(app)
    await runner.setup()
    site = web.TCPSite(runner, "0.0.0.0", 9090)
    await site.start()

    await monitor_loop()  # Запускаем мониторинг

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except Exception as e:
        print(f"[watchdog] Critical error: {e}")
