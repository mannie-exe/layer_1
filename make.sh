#!/usr/bin/env bash

set -e

#
# Argument parsing
#
# Run/Make target argument parsing and validation
#
# Target definitions use an index-first approach where execution order
# is implicit in array index and all metadata is grouped together.
# Invoked arguments are de-duplicated and sorted by execution priority.
#

# Target definitions - index matters
# Format: "name:description"
declare -a TARGETS=(
  "clean:Clean the dist (build) directories"
  "mrpack:Build a Modrinth-compatible '*.mrpack' file"
  "instance:Build a launcher-importable instance; uses packwiz-installer instead of embedding mods"
  "server:Build a non-redistributable server (⚠️  embeds non-redistributable content)"
  "client:Build a non-redistributable client (⚠️  embeds non-redistributable content)"
  "all:Equivalent to 'mrpack instance'"
)

function get_target_name() {
  echo "${TARGETS[$1]}" | cut -d: -f1
}

function get_target_description() {
  echo "${TARGETS[$1]}" | cut -d: -f2-
}

function get_target_order_by_name() {
  local target="$1"
  for i in "${!TARGETS[@]}"; do
    if [ "$(get_target_name "$i")" = "$target" ]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

function is_valid_target() {
  local target="$1"
  for i in "${!TARGETS[@]}"; do
    if [ "$(get_target_name "$i")" = "$target" ]; then
      return 0
    fi
  done
  return 1
}

function list_targets() {
  echo "Available targets:"
  for i in "${!TARGETS[@]}"; do
    printf "  %-10s - %s\n" "$(get_target_name "$i")" "$(get_target_description "$i")"
  done
}

function print_help() {
  echo "Usage: $0 [target1] [target2] ..."

  echo

  echo "Build system for Minecraft modpacks. Multiple targets can be specified and will be"
  echo "automatically sorted by execution priority and deduplicated."

  echo

  echo "Examples:"
  echo "  $0 mrpack              # Build just the .mrpack file"
  echo "  $0 clean mrpack        # Clean then build .mrpack"
  echo "  $0 instance server     # Build both instance and server (sorted: instance, server)"
  echo "  $0 all                 # Equal to 'mrpack instance'"

  echo

  list_targets
}

# Help override (help, --help, -h, [no args])
if [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$#" -eq 0 ]; then
  print_help
  exit 0
fi

declare -a RUN_TARGETS

for arg in "$@"; do
  if ! is_valid_target "$arg"; then
    echo "‼️ Invalid make target: $arg"
    echo
    print_help
    exit 1
  fi

  if [ "$arg" = "all" ]; then
    echo "💡 Running all targets (mrpack instance)"
    RUN_TARGETS=("mrpack" "instance")
    break
  fi

  duplicate=false
  for existing in "${RUN_TARGETS[@]}"; do
    if [ "$existing" = "$arg" ]; then
      duplicate=true
      break
    fi
  done

  if [ "$duplicate" = false ]; then
    RUN_TARGETS+=("$arg")
  fi
done

if [ "${#RUN_TARGETS[@]}" -gt 1 ] && [ "${RUN_TARGETS[0]}" != "all" ]; then
  # Sort by execution order priority (lower index = higher priority)
  for ((i = 0; i < ${#RUN_TARGETS[@]}; i++)); do
    for ((j = 0; j < ${#RUN_TARGETS[@]} - i - 1; j++)); do
      order_j=$(get_target_order_by_name "${RUN_TARGETS[j]}")
      order_j_plus_1=$(get_target_order_by_name "${RUN_TARGETS[j + 1]}")
      if [[ $order_j -gt $order_j_plus_1 ]]; then
        temp="${RUN_TARGETS[j]}"
        RUN_TARGETS[j]="${RUN_TARGETS[j + 1]}"
        RUN_TARGETS[j + 1]="$temp"
      fi
    done
  done
fi

function contains_target() {
  local target="$1"
  for run_target in "${RUN_TARGETS[@]}"; do
    if [ "$run_target" = "$target" ]; then
      return 0
    fi
  done
  return 1
}

function clean() {
  if [ "$1" != "dist" ] && [ "$1" != "client" ] && [ "$1" != "server" ] && [ "$1" != "instance" ]; then
    echo "‼️ Invalid clean target: $1"
    exit 1
  fi

  if [ "$1" = "dist" ]; then
    # Check if there are files to clean (besides subdirectories)
    if [ -z "$(find dist -mindepth 1 -maxdepth 1 ! -name 'client' ! -name 'server' ! -name 'instance' -print -quit)" ]; then
      return
    fi

    echo "🧼 Cleaning 'dist' root builds"
    find dist -mindepth 1 -maxdepth 1 \
      ! -name 'client' \
      ! -name 'server' \
      ! -name 'instance' \
      -delete
    return
  fi

  # Check if there are files to clean (besides .gitkeep)
  if [ -z "$(find dist/$1 -mindepth 1 ! -name '.gitkeep' -print -quit)" ]; then
    return
  fi

  echo "🧼 Cleaning $1 build in 'dist/$1'"
  find dist/$1 -mindepth 1 \
    ! -name '.gitkeep' \
    -delete
}

PACK_FILE="pack/pack.toml"

if [ ! -f "$PACK_FILE" ]; then
  echo "‼️ Pack file not found: $PACK_FILE"
  exit 1
fi

VERSION=$(tq -f $PACK_FILE 'version' | sed 's/"//g')

echo "♻️  Using pack file: $PACK_FILE (version: $VERSION)"
packwiz --pack-file $PACK_FILE refresh

if contains_target "clean"; then
  clean dist
  # Note: other targets will handle cleaning themselves
fi

if contains_target "mrpack"; then
  echo "📦 Packing modpack (Modrinth)"

  rm -f dist/layer_1-v${VERSION}.mrpack
  packwiz --pack-file $PACK_FILE \
    mr export \
    -o "dist/layer_1-v${VERSION}.mrpack"

  echo "✅ Modrinth export ready at 'dist/layer_1-v${VERSION}.mrpack'"
fi

function zip_dist() {
  if [ "$1" != "client" ] && [ "$1" != "server" ] && [ "$1" != "instance" ]; then
    echo "‼️ Invalid zip dist target: $1"
    exit 1
  fi

  if [ -z "$(find dist/$1 -mindepth 1 ! -name '.gitkeep' -print -quit)" ]; then
    echo "‼️ No files to zip in 'dist/$1'"
    return
  fi

  if [ "$1" = "instance" ]; then
    FILENAME="layer_1-v${VERSION}.zip"
  else
    FILENAME="layer_1-v${VERSION}-${1}.zip"
  fi

  rm -f dist/$FILENAME
  pushd dist/$1 >/dev/null
  zip -r0 ../$FILENAME ./ -x '.gitkeep'
  popd >/dev/null

  echo "✅ Exported $1 ready at 'dist/$FILENAME'"
}

if contains_target "instance" || contains_target "clean"; then

  clean instance

  if contains_target "instance"; then

    rm -f dist/layer_1-v${VERSION}.zip

    cp -r templates/instance/* dist/instance/

    mkdir -p dist/instance/.minecraft
    cp installer/packwiz-installer-bootstrap.jar dist/instance/.minecraft
    cp -r pack dist/instance/.minecraft

    MRPACK_FILE="dist/layer_1-v${VERSION}.mrpack"

    if [ -f "$MRPACK_FILE" ]; then
      TEMP_DIR="dist/temp-mrpack-extract"
      mkdir -p "$TEMP_DIR"
      unzip -q "$MRPACK_FILE" -d "$TEMP_DIR"

      if [ -d "$TEMP_DIR/overrides" ]; then
        cp -r "$TEMP_DIR/overrides"/* dist/instance/.minecraft/
      else
        echo "⚠️  No overrides folder found in mrpack"
      fi

      rm -rf "$TEMP_DIR"
    else
      echo "⚠️  mrpack file not found: $MRPACK_FILE"
      echo "💡 Run './make.sh mrpack' first to generate the mrpack"
      exit 1
    fi

    zip_dist instance
  fi
fi

if contains_target "server" || contains_target "clean"; then

  clean server

  if contains_target "server"; then

    cp -r templates/server/* dist/server/
    sed -i '' "s/{{VERSION}}/$VERSION/g" dist/server/server.properties

    MC_VERSION=$(tq -f $PACK_FILE 'versions.minecraft' | sed 's/"//g')
    FABRIC_VERSION=$(tq -f $PACK_FILE 'versions.fabric' | sed 's/"//g')

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

    zip_dist server
  fi
fi

if contains_target "client" || contains_target "clean"; then

  clean client

  if contains_target "client"; then

    pushd dist/client >/dev/null

    java -jar ../../installer/packwiz-installer-bootstrap.jar \
      --bootstrap-main-jar ../../installer/packwiz-installer.jar \
      -g -s both \
      "../../pack/pack.toml"

    popd >/dev/null

    zip_dist client
  fi
fi
