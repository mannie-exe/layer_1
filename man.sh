#!/usr/bin/env bash

set -e

POSSIBLE_TASKS=(
  "list:mods:client"
  "list:mods:server"
  "list:mods"
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
TOTAL_MODS=$(ls pack/mods/*.pw.toml | wc -l | xargs -L1 echo)

function list_sided_mods() {
  if [ "$1" = "both" ]; then
    echo "📦 $NAME v${VERSION}: All mods"
  else
    echo "📦 $NAME v${VERSION}: ${1}-only mods"
  fi

  PROCESSED=0
  FOUND=0
  MODS=()

  echo "🔍 Scanning $TOTAL_MODS mods..."

  for MOD in pack/mods/*.pw.toml; do
    PROCESSED=$((PROCESSED + 1))
    printf "\r⏳ Processing mod %d/%d..." $PROCESSED $TOTAL_MODS

    SIDE=$(tq -f $MOD 'side' 2>/dev/null | sed 's/"//g' || echo "")
    MODNAME=$(tq -f $MOD 'name' | sed 's/"//g')

    # Filter logic:
    # - "both": show all mods
    # - "client": only show mods explicitly marked side = "client"
    # - "server": only show mods explicitly marked side = "server"
    if [ "$1" = "both" ]; then
      FOUND=$((FOUND + 1))
      MODS+=("  $FOUND. $MODNAME")
    elif [ "$SIDE" = "$1" ]; then
      FOUND=$((FOUND + 1))
      MODS+=("  $FOUND. $MODNAME")
    fi
  done

  # Clear progress line and show results w/ summary at the bottom
  printf "\r"
  for MOD in "${MODS[@]}"; do
    echo "$MOD"
  done
  if [ "$1" = "both" ]; then
    echo "✅ Found ${#MODS[@]} total mods:"
  else
    echo "✅ Found ${#MODS[@]} ${1}-only mods:"
  fi
}

if [ "$1" = "list:mods:client" ]; then
  list_sided_mods "client"
  exit 0
fi

if [ "$1" = "list:mods:server" ]; then
  list_sided_mods "server"
  exit 0
fi

if [ "$1" = "list:mods" ]; then
  list_sided_mods "both"
  exit 0
fi
