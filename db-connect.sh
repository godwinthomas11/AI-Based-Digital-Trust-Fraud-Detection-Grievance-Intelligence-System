#!/bin/bash
# Opens an interactive mysql prompt against the Aiven DB used by the app.
# Reads credentials at run time from Tomcat's setenv.sh — no secrets stored here.
#
# Usage:
#   ./db-connect.sh              # interactive SQL shell
#   ./db-connect.sh "SHOW TABLES;"   # one-shot query

set -e

SETENV="/opt/homebrew/Cellar/tomcat@9/9.0.117/libexec/bin/setenv.sh"
if [ ! -f "$SETENV" ]; then
  echo "ERROR: setenv.sh not found at $SETENV" >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$SETENV"

if [ -z "$DB_URL" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
  echo "ERROR: DB_URL / DB_USER / DB_PASSWORD not set in setenv.sh" >&2
  exit 1
fi

HOST=$(echo "$DB_URL" | sed -E 's|jdbc:mysql://([^:/?]+).*|\1|')
PORT=$(echo "$DB_URL" | sed -E 's|jdbc:mysql://[^:]+:([0-9]+).*|\1|')
DBNAME=$(echo "$DB_URL" | sed -E 's|jdbc:mysql://[^/]+/([^?]+).*|\1|')

echo "Connecting to $HOST:$PORT / $DBNAME  as  $DB_USER"
echo "(Ctrl+D or \\q to exit)"
echo

export MYSQL_PWD="$DB_PASSWORD"

if [ $# -eq 0 ]; then
  exec mysql -h "$HOST" -P "$PORT" -u "$DB_USER" --ssl-mode=REQUIRED "$DBNAME"
else
  exec mysql -h "$HOST" -P "$PORT" -u "$DB_USER" --ssl-mode=REQUIRED "$DBNAME" -e "$*"
fi
