#!/bin/bash
# Helper script to find the upstream commit at a specific date
# Usage: ./find_upstream_at_date.sh "YYYY-MM-DD"

if [ -z "$1" ]; then
  echo "Usage: $0 <date>"
  echo "Example: $0 2023-06-15"
  exit 1
fi

TARGET_DATE="$1"
UPSTREAM_DIR="/tmp/upstream-ebusd-config"

# Clone upstream if not exists
if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Cloning upstream repository..."
  git clone https://github.com/john30/ebusd-configuration.git "$UPSTREAM_DIR"
fi

cd "$UPSTREAM_DIR"
git fetch --all --tags

echo "============================================"
echo "Finding upstream state at: $TARGET_DATE"
echo "============================================"
echo ""

# Find commit closest to the date
COMMIT=$(git rev-list -1 --before="$TARGET_DATE 23:59:59" --all)

if [ -z "$COMMIT" ]; then
  echo "ERROR: No commit found before $TARGET_DATE"
  exit 1
fi

COMMIT_DATE=$(git log -1 --format="%ai" "$COMMIT")
COMMIT_MSG=$(git log -1 --format="%s" "$COMMIT")

echo "Found commit: $COMMIT"
echo "Date: $COMMIT_DATE"
echo "Message: $COMMIT_MSG"
echo ""

# Check if there's a tag at or near this commit
TAG=$(git describe --tags --exact-match "$COMMIT" 2>/dev/null || git describe --tags --abbrev=0 "$COMMIT" 2>/dev/null || echo "")

if [ -n "$TAG" ]; then
  echo "This corresponds to tag: $TAG"
  echo ""
  echo "To compare your fork against this version, run:"
  echo "  ./compare_with_upstream.sh $TAG"
else
  echo "No tag found for this commit."
  echo ""
  echo "To compare your fork against this version, run:"
  echo "  ./compare_with_upstream.sh $COMMIT"
fi

echo ""
echo "Recent commits around this date:"
git log --oneline --since="$TARGET_DATE -7 days" --until="$TARGET_DATE +7 days" | head -15
