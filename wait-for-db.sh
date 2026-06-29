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
  if node -e "
    const net = require('net');
    const s = new net.Socket();
    s.setTimeout(5000);
    s.connect(parseInt(process.env.DB_POSTGRESDB_PORT||'5432'), process.env.DB_POSTGRESDB_HOST, ()=>{ s.destroy(); process.exit(0); });
    s.on('error', ()=>process.exit(1));
    s.on('timeout', ()=>process.exit(1));
  " 2>/dev/null; then
    echo "Postgres is ready — waiting 3s for full readiness ..."
    sleep 3
    exec n8n start
  fi
  i=$((i + 1))
  echo "  attempt $i/$RETRIES — not ready yet, retrying in ${WAIT_SECS}s ..."
  sleep $WAIT_SECS
done

echo "ERROR: Postgres did not become ready in time. Exiting."
exit 1
