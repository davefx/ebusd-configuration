# Fork Changes Analysis

## Overview

This document helps identify the changes in your fork (`davefx/ebusd-configuration`) compared to the upstream repository (`john30/ebusd-configuration`).

## Upstream Repository

- **Upstream**: https://github.com/john30/ebusd-configuration
- **Your Fork**: https://github.com/davefx/ebusd-configuration

## Current Branch Status

- **Branch**: `copilot/update-changes-for-new-structure`
- **Base Commit**: `601bca4` - "Uploading fixes" by David Marín (2026-01-13)
- **Total Files**: 509 files

## How to Compare with Upstream

Since this is a shallow clone, to get an exhaustive list of YOUR specific changes (excluding upstream merges), follow these steps:

### Step 1: Clone the Upstream Repository

```bash
git clone https://github.com/john30/ebusd-configuration.git /tmp/upstream-ebusd
```

### Step 2: Compare Your Fork Against Upstream

From within your repository directory:

```bash
# Get list of all files in your fork
find . -type f -not -path './.git/*' | sort > /tmp/your-files.txt

# Get list of all files in upstream
cd /tmp/upstream-ebusd
find . -type f -not -path './.git/*' | sort > /tmp/upstream-files.txt

# Find files only in your fork
comm -23 /tmp/your-files.txt /tmp/upstream-files.txt > /tmp/files-only-in-fork.txt

# Find files in both (potential modifications)
comm -12 /tmp/your-files.txt /tmp/upstream-files.txt > /tmp/common-files.txt
```

### Step 3: Check for Modified Files

```bash
# For each common file, compare content
while read file; do
  if ! diff -q "/path/to/your/fork/$file" "/tmp/upstream-ebusd/$file" > /dev/null 2>&1; then
    echo "$file" >> /tmp/modified-files.txt
  fi
done < /tmp/common-files.txt
```

### Step 4: Generate Summary Report

```bash
echo "=== FILES ONLY IN YOUR FORK ===" > /tmp/fork-changes-report.txt
cat /tmp/files-only-in-fork.txt >> /tmp/fork-changes-report.txt
echo "" >> /tmp/fork-changes-report.txt
echo "=== MODIFIED FILES ===" >> /tmp/fork-changes-report.txt
cat /tmp/modified-files.txt >> /tmp/fork-changes-report.txt
```

## Quick Alternative: Using GitHub

You can also compare branches directly on GitHub:

1. Go to: https://github.com/davefx/ebusd-configuration/compare/master...john30:ebusd-configuration:master
2. This will show you all differences between your fork and upstream

## Files in Current Branch

Based on commit `601bca4`, this branch contains:

### Root Level (9 files)
- `.gitignore`
- `ChangeLog.md`
- `LICENSE`
- `README.md`
- `VERSION`
- `latest` (symlink)
- `make_all.sh`
- `make_debian.sh`
- `make_tgz.sh`

### Version Directories

1. **ebusd-0.5.x/** (31 files)
   - ochsner/ (3 files)
   - protherm/ (4 files)
   - vaillant/ (18 files)
   - wolf/ (6 files)

2. **ebusd-1.x.x/** (44 files)
   - ochsner/ (4 files)
   - vaillant_de/ (40 files)

3. **ebusd-2.1.x/** (270 files)
   - de/ (135 files: 94 CSV, 41 INC)
   - en/ (135 files: 94 CSV, 41 INC)

4. **ebusd-2.x.x/** (127 files)
   - de/ (66 files)
   - en/ (61 files)

5. **libebus-0.1.x/** (14 files)
   - vaillant/ (12 files)
   - wolf/ (2 files)

6. **libebus-0.2.x/** (14 files)
   - vaillant/ (12 files)
   - wolf/ (2 files)

## Identifying Your Specific Changes

To identify ONLY your changes (not upstream):

### Method 1: File Comparison
Compare each file in your fork with the corresponding file in upstream:
- If file exists in upstream with same content → **No change**
- If file exists in upstream with different content → **Your modification**
- If file doesn't exist in upstream → **Your addition**

### Method 2: Git Commit History
If you had full git history (not shallow clone):
```bash
# This would show your commits that aren't in upstream
git log upstream/master..HEAD --oneline
```

### Method 3: Use GitHub Compare
The easiest way without local comparison:
1. Navigate to your fork on GitHub
2. Click "Compare" or create a pull request to upstream
3. This will show all your changes vs upstream

## Next Steps

1. **Clone upstream repository** to /tmp or another location
2. **Run the comparison scripts** above
3. **Document the differences** in a separate file
4. **Create a list** of:
   - New files you added
   - Files you modified (with description of changes)
   - Files you deleted (if any)

## Automated Comparison Script

Save this as `compare_with_upstream.sh`:

```bash
#!/bin/bash
FORK_DIR="/home/runner/work/ebusd-configuration/ebusd-configuration"
UPSTREAM_DIR="/tmp/upstream-ebusd"

# Clone upstream if not exists
if [ ! -d "$UPSTREAM_DIR" ]; then
  echo "Cloning upstream repository..."
  git clone https://github.com/john30/ebusd-configuration.git "$UPSTREAM_DIR"
fi

# Compare
echo "Comparing fork with upstream..."

# Added files
echo "=== NEW FILES IN FORK ===" > fork-analysis.txt
cd "$FORK_DIR"
find . -type f -not -path './.git/*' | while read file; do
  if [ ! -f "$UPSTREAM_DIR/$file" ]; then
    echo "$file" >> fork-analysis.txt
  fi
done

# Modified files
echo "" >> fork-analysis.txt
echo "=== MODIFIED FILES ===" >> fork-analysis.txt
find . -type f -not -path './.git/*' | while read file; do
  if [ -f "$UPSTREAM_DIR/$file" ]; then
    if ! diff -q "$file" "$UPSTREAM_DIR/$file" > /dev/null 2>&1; then
      echo "$file" >> fork-analysis.txt
    fi
  fi
done

echo "Analysis complete. See fork-analysis.txt"
```

---

**Note**: Due to the shallow clone nature of this repository, the complete git history is not available. The comparison must be done by comparing file contents directly with the upstream repository.
