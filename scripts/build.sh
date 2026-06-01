#!/bin/bash
set -e

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Error: No version provided"
  exit 1
fi

echo "Updating Xcode project version to $VERSION..."
python3 scripts/update-version.py "$VERSION"

echo "Building Xcode project..."
xcodebuild -project LinearSwipe.xcodeproj -scheme LinearSwipe -configuration Release -derivedDataPath Build/

echo "Locating and packaging application bundle..."
APP_PATH=$(find Build -name "LinearSwipe.app" -type d | head -n 1)
if [ -z "$APP_PATH" ]; then
  echo "Error: LinearSwipe.app not found"
  exit 1
fi

APP_DIR=$(dirname "$APP_PATH")
APP_NAME=$(basename "$APP_PATH")

cd "$APP_DIR"
zip -r "${GITHUB_WORKSPACE}/LinearSwipe.zip" "$APP_NAME"

echo "Package created at ${GITHUB_WORKSPACE}/LinearSwipe.zip"
