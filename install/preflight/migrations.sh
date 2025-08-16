#!/bin/bash

# Get the directory where the main script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

omadora_migrations_state_path=~/.local/state/omadora/migrations
mkdir -p $omadora_migrations_state_path

# Determine migrations path based on where we're running from
if [ -d "$SCRIPT_DIR/migrations" ]; then
  MIGRATIONS_PATH="$SCRIPT_DIR/migrations"
else
  MIGRATIONS_PATH="~/.local/share/omadora/migrations"
fi

for file in "$MIGRATIONS_PATH"/*.sh; do
  [ -e "$file" ] && touch "$omadora_migrations_state_path/$(basename "$file")"
done
