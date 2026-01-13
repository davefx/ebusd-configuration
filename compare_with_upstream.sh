#!/bin/bash
# Script to compare this fork with upstream and generate a detailed change list
# Usage: ./compare_with_upstream.sh [UPSTREAM_COMMIT_OR_TAG]
#
# Examples:
#   ./compare_with_upstream.sh                    # Compare with current upstream master
#   ./compare_with_upstream.sh v21.3              # Compare with specific tag
#   ./compare_with_upstream.sh abc123             # Compare with specific commit
#   ./compare_with_upstream.sh "HEAD@{2023-01-01}" # Compare with upstream at specific date

set -e

FORK_DIR="$(pwd)"
UPSTREAM_DIR="/tmp/upstream-ebusd-config"
UPSTREAM_REF="${1:-master}"  # Default to master if no argument provided
OUTPUT_FILE="YOUR_CHANGES.md"

echo "============================================"
echo "Fork vs Upstream Comparison Script"
echo "============================================"
echo ""
echo "Comparing against upstream ref: $UPSTREAM_REF"
echo ""

# Clone upstream if not exists
if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Cloning upstream repository john30/ebusd-configuration..."
  git clone https://github.com/john30/ebusd-configuration.git "$UPSTREAM_DIR"
  echo "✓ Upstream cloned"
else
  echo "Upstream repository already exists at $UPSTREAM_DIR"
  echo "Fetching latest changes..."
  cd "$UPSTREAM_DIR"
  git fetch --all --tags
  cd "$FORK_DIR"
  echo "✓ Upstream updated"
fi

# Checkout the specified upstream reference
echo "Checking out upstream ref: $UPSTREAM_REF"
cd "$UPSTREAM_DIR"
git checkout "$UPSTREAM_REF" || {
  echo "ERROR: Could not checkout '$UPSTREAM_REF'"
  echo "Available tags:"
  git tag | tail -10
  echo ""
  echo "Recent commits:"
  git log --oneline -10
  exit 1
}
UPSTREAM_COMMIT=$(git rev-parse HEAD)
UPSTREAM_DATE=$(git log -1 --format="%ai")
cd "$FORK_DIR"
echo "✓ Using upstream commit: $UPSTREAM_COMMIT"
echo "  Date: $UPSTREAM_DATE"
echo ""

echo ""
echo "Analyzing differences..."
echo ""

# Initialize output file
cat > "$OUTPUT_FILE" << EOF
# Your Fork Changes vs Upstream

This document lists all changes in your fork (\`davefx/ebusd-configuration\`) compared to the upstream repository (\`john30/ebusd-configuration\`).

**Generated**: $(date)
**Upstream**: https://github.com/john30/ebusd-configuration
**Upstream Commit**: $UPSTREAM_COMMIT
**Upstream Date**: $UPSTREAM_DATE
**Upstream Ref Used**: $UPSTREAM_REF
**Your Fork**: https://github.com/davefx/ebusd-configuration

---

EOF

# Count files
ADDED_COUNT=0
MODIFIED_COUNT=0
DELETED_COUNT=0

# Create temporary files for tracking
TMP_ADDED="/tmp/fork-added.txt"
TMP_MODIFIED="/tmp/fork-modified.txt"
TMP_DELETED="/tmp/fork-deleted.txt"

> "$TMP_ADDED"
> "$TMP_MODIFIED"
> "$TMP_DELETED"

# Find added files (in fork but not in upstream)
echo "Finding new files added to fork..."
cd "$FORK_DIR"
while IFS= read -r -d '' file; do
  rel_file="${file#./}"
  if [ ! -f "$UPSTREAM_DIR/$rel_file" ]; then
    echo "$rel_file" >> "$TMP_ADDED"
    ((ADDED_COUNT++))
  fi
done < <(find . -type f -not -path './.git/*' -not -path './YOUR_CHANGES.md' -not -path './FORK_CHANGES.md' -not -path './README_COMPARISON.md' -not -path './STEP_BY_STEP.md' -not -path './USAGE.txt' -not -path './USAGE.md' -not -path './compare_with_upstream.sh' -not -path './find_upstream_at_date.sh' -print0)

# Find modified files
echo "Finding modified files..."
cd "$FORK_DIR"
while IFS= read -r -d '' file; do
  rel_file="${file#./}"
  if [ -f "$UPSTREAM_DIR/$rel_file" ]; then
    if ! diff -q "$file" "$UPSTREAM_DIR/$rel_file" > /dev/null 2>&1; then
      echo "$rel_file" >> "$TMP_MODIFIED"
      ((MODIFIED_COUNT++))
    fi
  fi
done < <(find . -type f -not -path './.git/*' -not -path './YOUR_CHANGES.md' -not -path './FORK_CHANGES.md' -not -path './README_COMPARISON.md' -not -path './STEP_BY_STEP.md' -not -path './USAGE.txt' -not -path './USAGE.md' -not -path './compare_with_upstream.sh' -not -path './find_upstream_at_date.sh' -print0)

# Find deleted files (in upstream but not in fork)
echo "Finding deleted files..."
cd "$UPSTREAM_DIR"
while IFS= read -r -d '' file; do
  rel_file="${file#./}"
  if [ ! -f "$FORK_DIR/$rel_file" ]; then
    echo "$rel_file" >> "$TMP_DELETED"
    ((DELETED_COUNT++))
  fi
done < <(find . -type f -not -path './.git/*' -print0)

# Generate report
cat >> "$OUTPUT_FILE" << EOF
## Summary

- **New files added**: $ADDED_COUNT
- **Files modified**: $MODIFIED_COUNT
- **Files deleted**: $DELETED_COUNT
- **Total changes**: $((ADDED_COUNT + MODIFIED_COUNT + DELETED_COUNT))

---

EOF

if [ $ADDED_COUNT -gt 0 ]; then
  cat >> "$OUTPUT_FILE" << 'EOF'
## New Files Added to Fork

These files exist in your fork but not in the upstream repository:

EOF
  cat "$TMP_ADDED" | sort | sed 's/^/- /' >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

if [ $MODIFIED_COUNT -gt 0 ]; then
  cat >> "$OUTPUT_FILE" << 'EOF'
## Modified Files

These files exist in both repositories but have different content:

EOF
  cat "$TMP_MODIFIED" | sort | sed 's/^/- /' >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  
  # Show diff summary for each modified file
  echo "### Detailed Differences" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  
  while read file; do
    echo "#### \`$file\`" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo '```diff' >> "$OUTPUT_FILE"
    diff -u "$UPSTREAM_DIR/$file" "$FORK_DIR/$file" | head -50 >> "$OUTPUT_FILE" || true
    echo '```' >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
  done < "$TMP_MODIFIED"
fi

if [ $DELETED_COUNT -gt 0 ]; then
  cat >> "$OUTPUT_FILE" << 'EOF'
## Files Deleted from Fork

These files exist in upstream but were removed from your fork:

EOF
  cat "$TMP_DELETED" | sort | sed 's/^/- /' >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

# Cleanup
rm -f "$TMP_ADDED" "$TMP_MODIFIED" "$TMP_DELETED"

echo ""
echo "============================================"
echo "Analysis Complete!"
echo "============================================"
echo ""
echo "Summary:"
echo "  - New files: $ADDED_COUNT"
echo "  - Modified files: $MODIFIED_COUNT"
echo "  - Deleted files: $DELETED_COUNT"
echo ""
echo "Detailed report saved to: $OUTPUT_FILE"
echo ""
