#!/bin/sh
# Wait for Neon (or any Postgres) to accept connections before starting n8n.
# Neon free-tier computes can take ~5-15 s to wake from auto-suspend.

HOST="${DB_POSTGRESDB_HOST}"
PORT="${DB_POSTGRESDB_PORT:-5432}"
RETRIES=30        # 30 × 3 s = 90 s max wait
WAIT_SECS=3

echo "Waiting for Postgres at ${HOST}:${PORT} ..."

i=0
while [ $i -lt $RETRIES ]; do
  if pg_isready -h "$HOST" -p "$PORT" -U "${DB_POSTGRESDB_USER}" -t 5 > /dev/null 2>&1; then
    echo "Postgres is ready — starting n8n."
    exec n8n start
  fi
  i=$((i + 1))
  echo "  attempt $i/$RETRIES — not ready yet, retrying in ${WAIT_SECS}s ..."
  sleep $WAIT_SECS
done

echo "ERROR: Postgres did not become ready in time. Exiting."
exit 1
