#!/usr/bin/env bash

set -e

POSSIBLE_MAKES=(
  "clean"
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
packwiz --pack-file $PACKFILE refresh

if [ "$MAKE" = "pack" ] || [ "$MAKE" = "mrpack" ] || [ "$MAKE" = "all" ]; then
  echo "📦 Packing modpack (Modrinth)"

  packwiz --pack-file $PACKFILE \
    mr export \
    -o "dist/layer_1-v${VERSION}.mrpack"

  if [ "$MAKE" = "pack" ] || [ "$MAKE" = "mrpack" ]; then
    exit 0
  fi
fi

function clean() {
  if [ "$1" != "client" ] && [ "$1" != "server" ]; then
    echo "‼️ Invalid side: $1"
    exit 1
  fi

  # Check if there are files to clean (besides .gitkeep)
  if [ -z "$(find dist/$1 -mindepth 1 ! -name '.gitkeep' -print -quit)" ]; then
    return
  fi

  echo "🧼 Cleaning $1 build"

  find dist/$1 -mindepth 1 \
    ! -name '.gitkeep' \
    -exec rm -rf {} \
    +
}

# Handle server build
if [ "$MAKE" = "server" ] || [ "$MAKE" = "clean" ] || [ "$MAKE" = "all" ]; then

  clean server

  if [ "$MAKE" = "server" ] || [ "$MAKE" = "all" ]; then
    MC_VERSION=$(tq -f $PACKFILE 'versions.minecraft' | sed 's/"//g')
    FABRIC_VERSION=$(tq -f $PACKFILE 'versions.fabric' | sed 's/"//g')

    pushd dist/server >/dev/null

    mrpack-install server \
      fabric --flavor-version $FABRIC_VERSION \
      --minecraft-version $MC_VERSION \
      --server-dir . \
      --server-file srv.jar

    java -jar ../../installer/packwiz-installer-bootstrap.jar \
      --bootstrap-main-jar ../../installer/packwiz-installer.jar \
      -g -s server \
      "../../pack/pack.toml"

    popd >/dev/null
  fi
fi

# Handle client build
if [ "$MAKE" = "client" ] || [ "$MAKE" = "clean" ] || [ "$MAKE" = "all" ]; then

  clean client

  if [ "$MAKE" = "client" ] || [ "$MAKE" = "all" ]; then
    pushd dist/client >/dev/null

    java -jar ../../installer/packwiz-installer-bootstrap.jar \
      --bootstrap-main-jar ../../installer/packwiz-installer.jar \
      -g -s both \
      "../../pack/pack.toml"

    popd >/dev/null
  fi
fi
