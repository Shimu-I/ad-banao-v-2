#!/usr/bin/env bash
# Runs every check on your own computer and writes one report file you can send back.
#
#   ./scripts/check_my_machine.sh                 basic: install, lint, tests, migrations, API check
#   ./scripts/check_my_machine.sh --postgres      also use a real PostgreSQL from Docker
#   ./scripts/check_my_machine.sh --browser       also click through sign up and sign in in a browser
#   ./scripts/check_my_machine.sh --postgres --browser
#
# Output: my-test-report.txt (contains no passwords or keys). Full logs are in .check-logs/
set -u
cd "$(dirname "${BASH_SOURCE[0]}")/.."
ROOT="$PWD"
WANT_PG=0; WANT_BROWSER=0
for a in "$@"; do case "$a" in --postgres) WANT_PG=1;; --browser) WANT_BROWSER=1;; *) echo "Unknown option $a"; exit 2;; esac; done

REPORT="$ROOT/my-test-report.txt"; LOGS="$ROOT/.check-logs"; rm -rf "$LOGS"; mkdir -p "$LOGS"
PY="$ROOT/.venv/bin/python"; PIDS=()
declare -a ROWS=()
cleanup() { for p in "${PIDS[@]:-}"; do [ -n "$p" ] && kill "$p" 2>/dev/null; done; }
trap cleanup EXIT

# step "name" logfile command...   -> records PASS or FAIL
step() {
  local name="$1" log="$LOGS/$2"; shift 2
  printf '%-52s' "$name ..."
  if "$@" >"$log" 2>&1; then echo PASS; ROWS+=("PASS  $name")
  else echo FAIL; ROWS+=("FAIL  $name   (log: .check-logs/$(basename "$log"))"); return 1; fi
}
skip() { echo "SKIP  $1"; ROWS+=("SKIP  $1   ($2)"); }

wait_for_api() { for _ in $(seq 1 40); do curl -sf http://localhost:8000/health >/dev/null 2>&1 && return 0; sleep 1; done; return 1; }
start_api() {  # start_api <database url> <log name>
  ( cd backend && DATABASE_URL="$1" UPLOAD_DIR="$LOGS/uploads" exec "$PY" -m uvicorn app.main:app --port 8000 >"$LOGS/$2" 2>&1 ) &
  PIDS+=($!); API_PID=$!
}
stop_api() { [ -n "${API_PID:-}" ] && kill "$API_PID" 2>/dev/null; wait "$API_PID" 2>/dev/null; API_PID=""; sleep 1; }

# Lets the demo admin user become an admin during these checks (development only).
export ADMIN_EMAILS=admin@demo.adbanao.test=banao-demo-secret

echo "AdBanao check on $(hostname) - $(date)"
echo

# 1. basics
PYV=$(python3 -c 'import sys;print("%d.%d"%sys.version_info[:2])' 2>/dev/null || echo none)
step "Python 3.11 or newer found (you have $PYV)" python.log python3 -c 'import sys;sys.exit(sys.version_info<(3,11))' || { echo "Install Python 3.11+ first."; }
step "Create virtual environment (.venv)" venv.log bash -c '[ -x .venv/bin/python ] || python3 -m venv .venv'
step "Install backend packages" pip.log bash -c '.venv/bin/python -m pip install -q --upgrade pip && .venv/bin/pip install -q -r backend/requirements-dev.txt ruff'
step "Lint (ruff)" ruff.log "$ROOT/.venv/bin/ruff" check backend
step "Automated tests (pytest)" pytest.log "$PY" -m pytest -q -ra -p no:cacheprovider

# 2. migrations + real server on SQLite
DB="$LOGS/check.db"; rm -f "$DB"
step "Create tables with migrations (SQLite)" migrate-sqlite.log bash -c "cd backend && DATABASE_URL=sqlite:///$DB ../.venv/bin/alembic upgrade head"
if curl -sf http://localhost:8000/health >/dev/null 2>&1; then
  skip "API check on SQLite" "something already uses port 8000; stop it and run again"
else
  start_api "sqlite:///$DB" api-sqlite.log
  if wait_for_api; then step "API check on SQLite (sign up, profile, brand, product, photo)" smoke-sqlite.log "$PY" scripts/smoke_test.py http://localhost:8000
    step "Demo users and demo admin (SQLite)" seed-sqlite.log "$PY" scripts/seed_demo.py http://localhost:8000
    step "Admin checks on SQLite (privileges, suspend, log, CSV)" admin-sqlite.log "$PY" scripts/e2e_admin.py http://localhost:8000
  else ROWS+=("FAIL  API starts on SQLite   (log: .check-logs/api-sqlite.log)"); echo "API did not start"; fi
  stop_api
fi

# 3. PostgreSQL
if [ "$WANT_PG" = 1 ]; then
  if ! command -v docker >/dev/null 2>&1; then skip "PostgreSQL checks" "docker is not installed"
  else
    PGURL="postgresql://adbanao:adbanao@localhost:5432/adbanao"
    if ! step "Start PostgreSQL in Docker" docker.log docker compose up -d db; then
      if grep -qi "permission denied" "$LOGS/docker.log"; then
        echo "  Docker needs permission. Run: sudo usermod -aG docker \$USER   then log out, log in, and run this again."
      fi
      PG_OK=0
    fi
  fi
  if [ "${PG_OK:-1}" = 1 ] && command -v docker >/dev/null 2>&1; then
    for _ in $(seq 1 30); do docker compose exec -T db pg_isready -U adbanao >/dev/null 2>&1 && break; sleep 1; done
    step "Create tables with migrations (PostgreSQL)" migrate-pg.log bash -c "cd backend && DATABASE_URL=$PGURL ../.venv/bin/alembic upgrade head"
    start_api "$PGURL" api-pg.log
    if wait_for_api; then step "API check on PostgreSQL" smoke-pg.log "$PY" scripts/smoke_test.py http://localhost:8000
      step "Demo users and demo admin (PostgreSQL)" seed-pg.log "$PY" scripts/seed_demo.py http://localhost:8000
      step "Admin checks on PostgreSQL" admin-pg.log "$PY" scripts/e2e_admin.py http://localhost:8000
    else ROWS+=("FAIL  API starts on PostgreSQL   (log: .check-logs/api-pg.log)"); fi
    stop_api
    step "Migration downgrade and upgrade again (PostgreSQL)" roundtrip-pg.log bash -c "cd backend && export DATABASE_URL=$PGURL && ../.venv/bin/alembic downgrade base && ../.venv/bin/alembic upgrade head"
  fi
else skip "PostgreSQL checks" "add --postgres to run them"; fi

# 4. browser
if [ "$WANT_BROWSER" = 1 ]; then
  step "Install browser test tools" playwright.log bash -c '.venv/bin/pip install -q playwright && .venv/bin/playwright install chromium'
  rm -f "$DB"; (cd backend && DATABASE_URL=sqlite:///$DB ../.venv/bin/alembic upgrade head >/dev/null 2>&1)
  start_api "sqlite:///$DB" api-browser.log
  ( cd frontend && exec "$PY" -m http.server 5173 >"$LOGS/web.log" 2>&1 ) & PIDS+=($!)
  if wait_for_api; then step "Browser: sign up, sign in, profile, sign out" e2e.log "$PY" scripts/e2e_auth.py
    step "Demo users for the admin page" seed-browser.log "$PY" scripts/seed_demo.py http://localhost:8000
    step "Browser: admin page (access, search, panel, dark, Bangla, mobile)" e2e-admin.log "$PY" scripts/e2e_admin_page.py
  else ROWS+=("FAIL  API starts for the browser test"); fi
  stop_api
else skip "Browser test" "add --browser to run it"; fi

# 5. report
{
  echo "AdBanao machine check"; echo "Date:    $(date -Is)"
  echo "System:  $(uname -srm)"; echo "Python:  $($PY --version 2>&1)"
  echo "Git:     $(git rev-parse --short HEAD 2>/dev/null) on $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  echo "Docker:  $(docker --version 2>/dev/null || echo not installed)"
  echo; echo "Results"; printf '%s\n' "${ROWS[@]}"
  for r in "${ROWS[@]}"; do case "$r" in FAIL*)
    f=$(echo "$r" | sed -n 's/.*(log: \(.*\))/\1/p'); [ -n "$f" ] && { echo; echo "---- last lines of $f ----"; tail -n 40 "$ROOT/$f" | sed -E 's#(postgresql|postgres)://[^ ]*#\1://***#g'; }
  ;; esac; done
} >"$REPORT"
echo; echo "Done. Send me the file: $REPORT"
! printf '%s\n' "${ROWS[@]}" | grep -q '^FAIL'
