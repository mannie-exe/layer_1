#!/usr/bin/env bash

set -e

POSSIBLE_MAKES=(
  "clean"
  "client"
  "server"
  "mrpack"
  "instance"
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
  MAKE="mrpack"
fi

PACKFILE="pack/pack.toml"

if [ ! -f "$PACKFILE" ]; then
  echo "‼️ Pack file not found: $PACKFILE"
  exit 1
fi

VERSION=$(tq -f $PACKFILE 'version' | sed 's/"//g')

echo "♻️ Using pack file: $PACKFILE (version: $VERSION)"
packwiz --pack-file $PACKFILE refresh

if [ "$MAKE" = "mrpack" ] || [ "$MAKE" = "all" ]; then
  echo "📦 Packing modpack (Modrinth)"

  packwiz --pack-file $PACKFILE \
    mr export \
    -o "dist/layer_1-v${VERSION}.mrpack"

  if [ "$MAKE" = "pack" ] || [ "$MAKE" = "mrpack" ]; then
    exit 0
  fi
fi

function clean() {
  if [ "$1" != "client" ] && [ "$1" != "server" ] && [ "$1" != "instance" ]; then
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

# Handle instance build
if [ "$MAKE" = "instance" ] || [ "$MAKE" = "clean" ] || [ "$MAKE" = "all" ]; then

  clean instance
  rm -f dist/layer_1-v${VERSION}.zip

  if [ "$MAKE" = "instance" ] || [ "$MAKE" = "all" ]; then
    cp -r instance-template/* dist/instance/

    mkdir -p dist/instance/.minecraft
    cp installer/packwiz-installer-bootstrap.jar dist/instance/.minecraft
    cp -r pack/* dist/instance/.minecraft

    MRPACK_FILE="dist/layer_1-v${VERSION}.mrpack"

    if [ -f "$MRPACK_FILE" ]; then
      TEMP_DIR="dist/temp-mrpack-extract"
      mkdir -p "$TEMP_DIR"
      unzip -q "$MRPACK_FILE" -d "$TEMP_DIR"

      if [ -d "$TEMP_DIR/overrides" ]; then
        cp -r "$TEMP_DIR/overrides"/* dist/instance/.minecraft/
      else
        echo "⚠️ No overrides folder found in mrpack"
      fi

      rm -rf "$TEMP_DIR"
    else
      echo "⚠️ mrpack file not found: $MRPACK_FILE"
      echo "💡 Run './make.sh mrpack' first to generate the mrpack"
      exit 1
    fi

    zip -r0 dist/layer_1-v${VERSION}.zip dist/instance -x '*.gitkeep'

    echo "✅ Instance export ready at dist/layer_1-v${VERSION}.zip"
  fi
fi

# Handle server build
if [ "$MAKE" = "server" ] || [ "$MAKE" = "clean" ] || [ "$MAKE" = "all" ]; then

  clean server

  if [ "$MAKE" = "server" ]; then
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

  if [ "$MAKE" = "client" ]; then
    pushd dist/client >/dev/null

    java -jar ../../installer/packwiz-installer-bootstrap.jar \
      --bootstrap-main-jar ../../installer/packwiz-installer.jar \
      -g -s both \
      "../../pack/pack.toml"

    popd >/dev/null
  fi
fi
