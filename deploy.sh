#!/bin/bash
# Restart the Studio's systemd user service (imagination-studio.service) and wait until the app answers again.
#   bash deploy.sh            # refuses while a job is queued or running (a restart would cut it off)
#   bash deploy.sh --force    # restart anyway
# Environment: SERVICE (default imagination-studio), PORT (default 7870), WAIT (seconds to wait for the app, default 120).
set -euo pipefail
SERVICE="${SERVICE:-imagination-studio}"
PORT="${PORT:-7870}"
WAIT="${WAIT:-120}"
FORCE=0
[ "${1:-}" = --force ] && FORCE=1

systemctl --user cat "$SERVICE.service" >/dev/null 2>&1 || {
  echo "no user service $SERVICE.service (~/.config/systemd/user/$SERVICE.service)" >&2
  exit 1
}

# A request from this computer to its loopback address needs no access key (app/access.py).
busy() {
  curl -s -m 5 "http://127.0.0.1:$PORT/api/jobs" 2>/dev/null | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except ValueError:
    sys.exit(1)
jobs = d if isinstance(d, list) else d.get("jobs", [])
n = sum(1 for j in jobs if j.get("status") in ("queued", "running"))
print(n)
sys.exit(0 if n else 1)'
}

if [ "$FORCE" = 0 ] && n="$(busy)"; then
  echo "$n job(s) queued or running: wait for them, or run: bash deploy.sh --force" >&2
  exit 2
fi

echo "restarting $SERVICE ..."
systemctl --user restart "$SERVICE.service"

for _ in $(seq 1 "$WAIT"); do
  if [ "$(curl -s -m 2 -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT/api/state" 2>/dev/null)" = 200 ]; then
    echo "$SERVICE is $(systemctl --user is-active "$SERVICE.service"), answering on port $PORT"
    ss -ltn "sport = :$PORT" | tail -n +2
    exit 0
  fi
  systemctl --user is-failed --quiet "$SERVICE.service" && break
  sleep 1
done

echo "$SERVICE did not answer on port $PORT; its last log lines:" >&2
journalctl --user -u "$SERVICE" -n 30 --no-pager >&2
exit 1
