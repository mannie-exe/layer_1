#!/usr/bin/env bash

if [ ! -f "pack/pack.toml" ]; then
  echo "‼️ Pack file not found: pack/pack.toml"
  exit 1
fi

VERSION=$(tq -f pack/pack.toml 'version' | sed 's/"//g')

echo "♻️ Using pack file: pack/pack.toml (version: $VERSION)"

pushd pack >/dev/null

packwiz refresh

packwiz mr export -o "../layer_1-${VERSION}.mrpack"

popd >/dev/null

echo "✅ Exported pack file: layer_1-${VERSION}.mrpack"
