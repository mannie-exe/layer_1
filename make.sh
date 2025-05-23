#!/usr/bin/env bash

set -e

POSSIBLE_MAKES=(
  "client"
  "server"
  "pack"
  "mrpack"
  "all"
)

if [ "$1" ]; then
  if [[ ! " ${POSSIBLE_MAKES[@]} " =~ " $1 " ]]; then
    echo "‼️ Invalid make target: $1"
    echo "Valid make targets: ${POSSIBLE_MAKES[@]}"
    exit 1
  fi

  MAKE="$1"
else
  MAKE="client"
fi

PACKFILE="pack/pack.toml"

if [ ! -f "$PACKFILE" ]; then
  echo "‼️ Pack file not found: $PACKFILE"
  exit 1
fi

VERSION=$(tq -f $PACKFILE 'version' | sed 's/"//g')

echo "♻️ Using pack file: $PACKFILE (version: $VERSION)"

if [ "$MAKE" = "pack" ] || [ "$MAKE" = "mrpack" ] || [ "$MAKE" = "all" ]; then
  packwiz --pack-file $PACKFILE \
    refresh
  packwiz --pack-file $PACKFILE \
    mr export \
    -o "dist/layer_1-${VERSION}.mrpack"

  if [ "$MAKE" = "pack" ] || [ "$MAKE" = "mrpack" ]; then
    exit 0
  fi
fi

if [ "$MAKE" = "server" ] || [ "$MAKE" = "all" ]; then
  pushd dist/server >/dev/null

  java -jar ../../installer/packwiz-installer-bootstrap.jar \
    --bootstrap-main-jar ../../installer/packwiz-installer.jar \
    -g -s server \
    "../../pack/pack.toml"

  popd >/dev/null
fi

if [ "$MAKE" = "client" ] || [ "$MAKE" = "all" ]; then
  pushd dist/client >/dev/null

  java -jar ../../installer/packwiz-installer-bootstrap.jar \
    --bootstrap-main-jar ../../installer/packwiz-installer.jar \
    -g -s both \
    "../../pack/pack.toml"

  popd >/dev/null
fi
