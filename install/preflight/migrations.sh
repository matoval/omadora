#!/bin/bash

omadora_migrations_state_path=~/.local/state/omadora/migrations
mkdir -p $omadora_migrations_state_path

# Always use installed location  
MIGRATIONS_PATH=~/.local/share/omadora/migrations

for file in "$MIGRATIONS_PATH"/*.sh; do
  [ -e "$file" ] && touch "$omadora_migrations_state_path/$(basename "$file")"
done
