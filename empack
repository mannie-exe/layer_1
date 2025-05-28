#!/usr/bin/env bash

set -e

#
# Argument parsing
#
# Run/Make command argument parsing and validation
#
# Command definitions use an index-first approach where execution order
# is implicit in array index and all metadata is grouped together.
# Invoked arguments are de-duplicated and sorted by execution priority.
#

# Command definitions - index matters
# Format: "name:description"
declare -a COMMANDS=(
  "clean:Clean the dist (build) directories"

  "mrpack:Build a Modrinth-compatible '*.mrpack' file"
  "client:Build a bootstrapped client installer"
  "server:Build a bootstrapped server installer"

  "client-full:Build a non-redistributable client (⚠️  embeds non-redistributable content)"
  "server-full:Build a non-redistributable server (⚠️  embeds non-redistributable content)"

  "all:Equivalent to 'mrpack client server'"
)

function get_command_name() {
  echo "${COMMANDS[$1]}" | cut -d: -f1
}

function get_command_description() {
  echo "${COMMANDS[$1]}" | cut -d: -f2-
}

function get_command_order_by_name() {
  local command="$1"
  for i in "${!COMMANDS[@]}"; do
    if [ "$(get_command_name "$i")" = "$command" ]; then
      echo "$i"
      return 0
    fi
  done
  return 1
}

function is_valid_command() {
  local command="$1"
  for i in "${!COMMANDS[@]}"; do
    if [ "$(get_command_name "$i")" = "$command" ]; then
      return 0
    fi
  done
  return 1
}

function list_commands() {
  echo "Available commands:"
  for i in "${!COMMANDS[@]}"; do
    printf "  %-10s - %s\n" "$(get_command_name "$i")" "$(get_command_description "$i")"
  done
}

function print_help() {
  echo "Usage: $0 [command1] [command2] ..."

  echo

  echo "Build system for Minecraft modpacks. Multiple commands can be specified and will be"
  echo "automatically sorted by execution priority and deduplicated."

  echo

  echo "Examples:"
  echo "  $0 mrpack              # Build just the .mrpack file"
  echo "  $0 clean mrpack        # Clean then build .mrpack"
  echo "  $0 client server       # Build both client and server (sorted: client, server)"
  echo "  $0 all                 # Equal to 'mrpack client server'"

  echo

  list_commands
}

# Help override (help, --help, -h, [no args])
if [ "$1" = "help" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$#" -eq 0 ]; then
  print_help
  exit 0
fi

declare -a RUN_COMMANDS

for arg in "$@"; do
  if ! is_valid_command "$arg"; then
    echo "‼️ Invalid make command: $arg"
    echo
    print_help
    exit 1
  fi

  if [ "$arg" = "all" ]; then
    echo "💡 Running all commands (mrpack client server)"
    RUN_COMMANDS=("mrpack" "client" "server")
    break
  fi

  duplicate=false
  for existing in "${RUN_COMMANDS[@]}"; do
    if [ "$existing" = "$arg" ]; then
      duplicate=true
      break
    fi
  done

  if [ "$duplicate" = false ]; then
    RUN_COMMANDS+=("$arg")
  fi
done

if [ "${#RUN_COMMANDS[@]}" -gt 1 ] && [ "${RUN_COMMANDS[0]}" != "all" ]; then
  # Sort by execution order priority (lower index = higher priority)
  for ((i = 0; i < ${#RUN_COMMANDS[@]}; i++)); do
    for ((j = 0; j < ${#RUN_COMMANDS[@]} - i - 1; j++)); do
      order_j=$(get_command_order_by_name "${RUN_COMMANDS[j]}")
      order_j_plus_1=$(get_command_order_by_name "${RUN_COMMANDS[j + 1]}")
      if [[ $order_j -gt $order_j_plus_1 ]]; then
        temp="${RUN_COMMANDS[j]}"
        RUN_COMMANDS[j]="${RUN_COMMANDS[j + 1]}"
        RUN_COMMANDS[j + 1]="$temp"
      fi
    done
  done
fi

function contains_command() {
  local command="$1"
  for run_command in "${RUN_COMMANDS[@]}"; do
    if [ "$run_command" = "$command" ]; then
      return 0
    fi
  done
  return 1
}

#
# Submodules management
#
# The '*.mrpack' output is considered primary, these are the modules besides
# that.
#
# 'client' and 'server' are the primary bootstrapped distributions for their
# respective sides.
#   client       - Prism/MultiMC-compatible instance that bootstrap with
#                  packwiz-installer and a local copy of the modpack
#   server       - Minecraft server-included instance with an 'install_pack.sh'
#                  script that bootstrap with packwiz-installer and a local copy
#                  of the modpack
# Both 'client' and 'server' include 'packwiz-installer-bootstrap.jar'.
#
# 'client-full' and 'server-full' are legally non-redistributable, as they
# include the full modpack content, but are provided for convenient development.
#

# Submodule pairs for validation and iteration
# Format: bootstrap_command full_command
declare -a SUBMODULES=(
  "client" "client-full"
  "server" "server-full"
)

readonly PACK_FILE="pack/pack.toml"

if [ ! -f "$PACK_FILE" ]; then
  echo "‼️ Pack file not found: $PACK_FILE"
  exit 1
fi

readonly AUTHOR=$(tq -f $PACK_FILE 'author' | sed 's/"//g')
readonly NAME=$(tq -f $PACK_FILE 'name' | sed 's/"//g')
readonly VERSION=$(tq -f $PACK_FILE 'version' | sed 's/"//g')
readonly MC_VERSION=$(tq -f $PACK_FILE 'versions.minecraft' | sed 's/"//g')
readonly FABRIC_VERSION=$(tq -f $PACK_FILE 'versions.fabric' | sed 's/"//g')

function clean() {
  # dist is a special target that only cleans resulting mrpack or zip files
  if [ "$1" != "dist" ] && [ "$1" != "client" ] && [ "$1" != "server" ] && [ "$1" != "client-full" ] && [ "$1" != "server-full" ]; then
    echo "‼️ Invalid clean target: $1"
    exit 1
  fi

  if [ "$1" = "dist" ]; then
    # Check if there are files to clean (besides subdirectories)
    if [ -z "$(find dist -mindepth 1 -maxdepth 1 ! -name 'client' ! -name 'server' ! -name 'client-full' ! -name 'server-full' -print -quit)" ]; then
      return
    fi

    echo "🧼 Cleaning 'dist' root builds"
    find dist -mindepth 1 -maxdepth 1 \
      ! -name 'client' \
      ! -name 'server' \
      ! -name 'client-full' \
      ! -name 'server-full' \
      -delete
    return
  fi

  # [ -z "$(find dist/$1 -mindepth 1 ! -name '.gitkeep' -print -quit)" ]
  # TODO: should be an inverse of above if, but fix if not standard or broken
  if [ ! -z "$(find dist/$1 -mindepth 1 ! -name '.gitkeep' -print -quit)" ]; then
    echo "🧼 Cleaning $1 build in 'dist/$1'"
    find dist/$1 -mindepth 1 \
      ! -name '.gitkeep' \
      -delete
  fi

  if [ -f "dist/${NAME}-v${VERSION}-$1.zip" ]; then
    echo "🧼 Cleaning $1 build in 'dist/${NAME}-v${VERSION}-$1.zip'"
    rm -f "dist/${NAME}-v${VERSION}-$1.zip"
  fi
}

function process_templates() {
  local template_dir="$1"
  local target_dir="$2"

  if [ ! -d "$template_dir" ]; then
    echo "‼️ Template directory not found: $template_dir"
    exit 1
  fi

  mkdir -p "$target_dir"

  for file in "$template_dir"/*; do
    [ -f "$file" ] || continue # Skip if no files match
    filename=$(basename "$file")

    if [[ $filename == *.template ]]; then
      # Remove .template suffix for output
      output_name="${filename%.template}"
      sed -e "s/{{VERSION}}/$VERSION/g" -e "s/{{NAME}}/$NAME/g" -e "s/{{AUTHOR}}/$AUTHOR/g" -e "s/{{MC_VERSION}}/$MC_VERSION/g" -e "s/{{FABRIC_VERSION}}/$FABRIC_VERSION/g" "$file" >"$target_dir/$output_name"
    else
      cp "$file" "$target_dir/"
    fi
  done
}

function zip_dist() {
  if [ "$1" != "client" ] && [ "$1" != "server" ] && [ "$1" != "client-full" ] && [ "$1" != "server-full" ]; then
    echo "‼️ Invalid zip target: $1"
    exit 1
  fi

  if [ -z "$(find dist/$1 -mindepth 1 ! -name '.gitkeep' -print -quit)" ]; then
    echo "‼️ No files to zip in 'dist/$1'"
    return
  fi

  FILENAME="${NAME}-v${VERSION}-${1}.zip"

  rm -f dist/$FILENAME

  pushd dist/$1 >/dev/null
  zip -r0 ../$FILENAME ./ -x '.gitkeep'
  popd >/dev/null

  echo "✅ Export '$1' ready at 'dist/$FILENAME'"
}

PACK_REFRESHED=false
MRPACK_EXTRACTED=false

function refresh_pack() {
  if [ "$PACK_REFRESHED" = true ]; then
    return
  fi

  echo "♻️  Using pack file: $PACK_FILE (version: $VERSION)"
  packwiz --pack-file $PACK_FILE refresh
  PACK_REFRESHED=true
}

function make_mrpack() {
  echo "📦 Packing modpack (Modrinth)"

  rm -f dist/${NAME}-v${VERSION}.mrpack
  packwiz --pack-file $PACK_FILE \
    mr export \
    -o "dist/${NAME}-v${VERSION}.mrpack"

  echo "✅ Modrinth export ready at 'dist/${NAME}-v${VERSION}.mrpack'"
}

function extract_mrpack() {
  if [ "$MRPACK_EXTRACTED" = true ]; then
    return
  fi

  MRPACK="dist/${NAME}-v${VERSION}.mrpack"

  if [ ! -f "$MRPACK" ]; then
    make_mrpack
  fi

  echo "📦 Extracting modpack (Modrinth)"

  rm -rf dist/temp-mrpack-extract
  mkdir -p dist/temp-mrpack-extract

  unzip -q dist/${NAME}-v${VERSION}.mrpack -d dist/temp-mrpack-extract

  MRPACK_EXTRACTED=true
}

if contains_command "clean"; then
  clean dist
  # Note: other commands will handle cleaning themselves
fi

if contains_command "mrpack"; then
  refresh_pack
  make_mrpack
fi

if contains_command "client" || contains_command "clean"; then

  clean client

  if contains_command "client"; then

    refresh_pack

    process_templates "templates/client" "dist/client"

    mkdir -p dist/client/.minecraft
    cp installer/packwiz-installer-bootstrap.jar dist/client/.minecraft
    cp -r pack dist/client/.minecraft

    extract_mrpack

    if [ -d "dist/temp-mrpack-extract/overrides" ]; then
      cp -r "dist/temp-mrpack-extract/overrides"/* dist/client/.minecraft/
    fi

    zip_dist client
  fi
fi

if contains_command "server" || contains_command "clean"; then

  clean server

  if contains_command "server"; then

    refresh_pack

    process_templates "templates/server" "dist/server"

    cp -r pack dist/server

    cp installer/packwiz-installer-bootstrap.jar dist/server

    mrpack-install server \
      fabric --flavor-version $FABRIC_VERSION \
      --minecraft-version $MC_VERSION \
      --server-dir dist/server \
      --server-file srv.jar

    extract_mrpack

    if [ -d "dist/temp-mrpack-extract/overrides" ]; then
      cp -r "dist/temp-mrpack-extract/overrides"/* dist/server/
    fi

    zip_dist server
  fi
fi

if contains_command "client-full" || contains_command "clean"; then

  clean client-full

  if contains_command "client-full"; then

    refresh_pack

    pushd dist/client-full >/dev/null

    java -jar ../../installer/packwiz-installer-bootstrap.jar \
      --bootstrap-main-jar ../../installer/packwiz-installer.jar \
      -g -s both \
      "../../pack/pack.toml"

    popd >/dev/null

    zip_dist client-full
  fi
fi

if contains_command "server-full" || contains_command "clean"; then

  clean server-full

  if contains_command "server-full"; then

    refresh_pack

    process_templates "templates/server" "dist/server-full"

    mrpack-install server \
      fabric --flavor-version $FABRIC_VERSION \
      --minecraft-version $MC_VERSION \
      --server-dir dist/server-full \
      --server-file srv.jar

    pushd dist/server-full >/dev/null

    java -jar ../../installer/packwiz-installer-bootstrap.jar \
      --bootstrap-main-jar ../../installer/packwiz-installer.jar \
      -g -s server \
      "../../pack/pack.toml"

    popd >/dev/null

    zip_dist server-full
  fi
fi

if [ "$MRPACK_EXTRACTED" = true ]; then
  rm -rf dist/temp-mrpack-extract
fi
