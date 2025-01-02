#!/usr/bin/env bash
set -e

# Ensure PostgreSQL service is running
service postgresql start

# Wait until PostgreSQL is ready
for i in {1..5}; do
  if pg_isready -q; then
    echo "PostgreSQL is ready!"
    break
  fi
  echo "Waiting for PostgreSQL..."
  sleep 5
done

# Initialize Metasploit database
msfdb init

# Execute the incoming command (default is bash)
exec "$@"