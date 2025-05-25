#!/usr/bin/env bash

set -e

POSSIBLE_TASKS=(
  "list:mods:client"
)

if [ -z "$1" ]; then
  echo "‼️ No command provided"
  echo "Usage: man.sh <command>"
  echo "Commands: ${POSSIBLE_TASKS[@]}"
  exit 1
fi

PACKFILE="pack/pack.toml"

if [ ! -f "$PACKFILE" ]; then
  echo "‼️ Pack file not found: $PACKFILE"
  exit 1
fi

NAME=$(tq -f $PACKFILE 'name' | sed 's/"//g')
VERSION=$(tq -f $PACKFILE 'version' | sed 's/"//g')

if [ "$1" = "list:mods:client" ]; then
  echo "📦 $NAME v${VERSION}: Client-side mods"

  TOTAL_MODS=$(ls pack/mods/*.pw.toml | wc -l)
  PROCESSED=0
  CLIENT_MODS=()

  echo "🔍 Scanning $TOTAL_MODS mods..."

  for MOD in pack/mods/*.pw.toml; do
    PROCESSED=$((PROCESSED + 1))
    printf "\r⏳ Processing mod %d/%d..." $PROCESSED $TOTAL_MODS

    SIDE=$(tq -f $MOD 'side' | sed 's/"//g')
    MODNAME=$(tq -f $MOD 'name' | sed 's/"//g')

    if [ "$SIDE" = "client" ]; then
      CLIENT_MODS+=("  $PROCESSED. $MODNAME")
    fi
  done

  # Clear progress line and show results
  printf "\r"
  echo "✅ Found ${#CLIENT_MODS[@]} client-side mods:"

  for MOD in "${CLIENT_MODS[@]}"; do
    echo "  $MOD"
  done
fi
