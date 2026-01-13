# Quick Start: Finding Your Fork Changes

## What You Asked For

You wanted an exhaustive list of changes YOU made in your fork, excluding any merges from the upstream `john30/ebusd-configuration` repository.

**Important**: You want to compare against the upstream state **just before your last merge**, not the current upstream (which has changed significantly).

## The Problem

This repository is a shallow clone (limited git history), which makes it impossible to use standard git commands like `git log upstream/master..HEAD` to identify your specific changes.

## The Solution

I've created tools to help you compare your fork file-by-file against a **specific version** of the upstream repository (e.g., the state just before your last merge).

## How to Use

### Step 1: Find the Right Upstream Commit/Tag

If you know the **date** of your last merge from upstream:

```bash
./find_upstream_at_date.sh "2023-06-15"
```

This will tell you the upstream commit or tag to use for comparison.

**OR** if you know a specific **tag** (e.g., v21.3, v22.1):

```bash
# List available upstream tags
git ls-remote --tags https://github.com/john30/ebusd-configuration.git | tail -20
```

### Step 2: Run the Comparison Script

Once you know which upstream version to compare against, run:

```bash
# Compare against a specific tag
./compare_with_upstream.sh v21.3

# OR compare against a specific commit
./compare_with_upstream.sh abc123def

# OR compare against current upstream master (if unsure)
./compare_with_upstream.sh
```

### Step 3: Review the Output

Open `YOUR_CHANGES.md` to see:
- Complete list of your additions
- Detailed diffs of your modifications  
- Summary statistics

## Examples

### Example 1: You last merged upstream on June 15, 2023

```bash
# Find the upstream commit at that date
./find_upstream_at_date.sh "2023-06-15"

# Output will tell you to run:
./compare_with_upstream.sh abc123  # (or a tag like v21.3)
```

### Example 2: You know you merged from tag v21.3

```bash
./compare_with_upstream.sh v21.3
```

### Example 3: You're not sure, compare with current upstream

```bash
./compare_with_upstream.sh
# This compares with latest upstream, so shows ALL differences including their new changes
```

## Files I Created

1. **FORK_CHANGES.md** - Detailed documentation about the comparison process
2. **compare_with_upstream.sh** - Automated comparison script with version support
3. **find_upstream_at_date.sh** - Helper to find upstream commit at a specific date
4. **README_COMPARISON.md** - This quick start guide

## What Gets Generated

When you run the script, you'll get:

```
YOUR_CHANGES.md
├── Metadata (upstream commit, date, ref used)
├── Summary (counts of added/modified/deleted)
├── New Files Added to Fork
│   ├── file1.csv
│   ├── file2.csv
│   └── ...
├── Modified Files
│   ├── file3.csv (with diff)
│   ├── file4.csv (with diff)
│   └── ...
└── Files Deleted from Fork
    └── (if any)
```

## Understanding the Output

The generated `YOUR_CHANGES.md` will show:

- **Upstream Ref Used**: The exact tag/commit you compared against
- **Upstream Date**: When that upstream version was created
- **Your changes**: Only differences between your fork and THAT specific upstream version

This means you won't see changes that upstream made AFTER your last merge.

## Alternative: Use GitHub's Compare Feature

You can also compare branches directly on GitHub:

**Current upstream**:
```
https://github.com/davefx/ebusd-configuration/compare/master...john30:ebusd-configuration:master
```

**Specific upstream version** (replace v21.3 with your tag):
```
https://github.com/davefx/ebusd-configuration/compare/master...john30:ebusd-configuration:v21.3
```

## Need Help Finding Your Last Merge Date?

Check your fork's commit history or GitHub pull requests:
1. Go to your fork on GitHub
2. Look for merge commits or pull requests from upstream
3. Note the date of the last merge
4. Use that date with `find_upstream_at_date.sh`

## Why This Approach?

Since your repository is a shallow clone (commit 601bca4 "Uploading fixes" is grafted), we don't have the full git history showing which commits came from upstream vs your own work. File-by-file comparison against a specific upstream version is the only reliable way to identify your specific changes while excluding upstream's subsequent changes.
