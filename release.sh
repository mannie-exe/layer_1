#!/usr/bin/env bash

if [[ -z $1 ]]; then
  echo "Usage: $0 <version>"
  echo "       $0 v0.1.0"
  echo "       $0 0.1.0 (same as above)"
  exit 1
fi

VERSION=${1/#v/}
echo
echo "🚀 Creating release: v${VERSION}"

echo "⚠️  WARNING: This script will create a tag and push it to the repository."
read -p "   Do you want to continue? [y/N] " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

git tag v${VERSION} && git push origin v${VERSION}
