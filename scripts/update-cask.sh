#!/bin/bash
set -e

VERSION=$1
if [ -z "$VERSION" ]; then
  echo "Error: No version provided"
  exit 1
fi

if [ -z "$HOMEBREW_TAP_TOKEN" ]; then
  echo "Warning: HOMEBREW_TAP_TOKEN is not set. Skipping Homebrew Cask update."
  exit 0
fi

echo "Calculating SHA-256 for LinearSwipe.zip..."
if [ ! -f "LinearSwipe.zip" ]; then
  echo "Error: LinearSwipe.zip not found"
  exit 1
fi
SHA256=$(shasum -a 256 LinearSwipe.zip | awk '{print $1}')
echo "SHA-256: $SHA256"

echo "Cloning ChilledEther/homebrew-tap..."
git clone "https://x-access-token:${HOMEBREW_TAP_TOKEN}@github.com/ChilledEther/homebrew-tap.git" homebrew-tap-repo

echo "Updating Cask file..."
CASK_FILE="homebrew-tap-repo/Casks/linearswipe.rb"

# Create Casks directory if it doesn't exist
mkdir -p "homebrew-tap-repo/Casks"

# If the Cask file doesn't exist yet, create it from the template
if [ ! -f "$CASK_FILE" ]; then
  echo "Creating initial Cask file..."
  cat <<EOF > "$CASK_FILE"
cask "linearswipe" do
  version "$VERSION"
  sha256 "$SHA256"

  url "https://github.com/ChilledEther/LinearSwipe/releases/download/v#{version}/LinearSwipe.zip"
  name "LinearSwipe"
  desc "Switch apps with trackpad on macOS"
  homepage "https://github.com/ChilledEther/LinearSwipe"

  app "LinearSwipe.app"

  zap trash: [
    "~/Library/Preferences/ris58h.LinearSwipe.plist",
  ]
end
EOF
else
  # Use our python helper to update version and sha256
  python3 scripts/update-cask-file.py "$VERSION" "$SHA256" "$CASK_FILE"
fi

cd homebrew-tap-repo
git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"

git add Casks/linearswipe.rb
git commit -m "chore(release): update linearswipe to v$VERSION" || echo "No changes to commit"

# Try pushing to main and master branches
git push origin main || git push origin master || echo "Failed to push"
