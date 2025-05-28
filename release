#!/usr/bin/env bash

PACKFILE="pack/pack.toml"

if [ ! -f "$PACKFILE" ]; then
  echo "‼️ Pack file not found: $PACKFILE"
  exit 1
fi

VERSION=$(tq -f $PACKFILE 'version' | sed 's/"//g')

echo "♻️ Using pack file: $PACKFILE (version: $VERSION)"
echo "🚀 Creating release: v${VERSION}"
echo "⚠️  WARNING: This script will create a tag and push it to the repository."

read -p "   Do you want to continue? [y/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

git tag v${VERSION} && git push origin v${VERSION}
