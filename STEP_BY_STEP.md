# Step-by-Step Guide: Generate Your Fork Changes List

This guide will help you generate an exhaustive list of YOUR changes, comparing against the upstream state **before it changed**.

## Before You Start

You mentioned that upstream has changed a lot since your last merge. To get an accurate list of YOUR changes only, you need to:

1. **Find** the upstream version you last merged from
2. **Compare** your fork against that specific version

## Step-by-Step Process

### Step 1: Determine When You Last Merged from Upstream

**Option A: You know the approximate date**
- Skip to Step 2

**Option B: Check your fork's history on GitHub**
1. Go to: https://github.com/davefx/ebusd-configuration/commits
2. Look for merge commits or commits mentioning "upstream" or "merge"
3. Note the date

**Option C: Check pull requests**
1. Go to: https://github.com/davefx/ebusd-configuration/pulls?q=is%3Apr
2. Look for any PR that merged from upstream
3. Note the merge date

### Step 2: Find the Upstream Commit at That Date

Once you have the date (e.g., "2023-06-15"), run:

```bash
./find_upstream_at_date.sh "2023-06-15"
```

**Example output:**
```
Found commit: abc123def456
Date: 2023-06-15 10:30:00 +0200
Message: Update configuration for v21.3
This corresponds to tag: v21.3

To compare your fork against this version, run:
  ./compare_with_upstream.sh v21.3
```

### Step 3: Run the Comparison

Using the commit or tag from Step 2:

```bash
./compare_with_upstream.sh v21.3
```

Or if no tag was found:

```bash
./compare_with_upstream.sh abc123def456
```

### Step 4: Review Your Changes

Open the generated file:

```bash
cat YOUR_CHANGES.md
```

or

```bash
less YOUR_CHANGES.md
```

This file contains:
- All files YOU added
- All files YOU modified (with diffs)
- All files YOU deleted
- Statistics on your changes

## Example Workflow

```bash
# 1. Find when you last merged (let's say June 15, 2023)
./find_upstream_at_date.sh "2023-06-15"

# Output tells you:
#   To compare your fork against this version, run:
#     ./compare_with_upstream.sh v21.3

# 2. Run comparison against that version
./compare_with_upstream.sh v21.3

# 3. Review your changes
less YOUR_CHANGES.md
```

## What If I Don't Know the Merge Date?

### Option 1: List Available Upstream Tags

```bash
git ls-remote --tags https://github.com/john30/ebusd-configuration.git
```

Pick a tag that looks familiar (e.g., v21.3, v22.1) and compare against it:

```bash
./compare_with_upstream.sh v21.3
```

### Option 2: Try Different Dates

Start with an early date and work forward:

```bash
./find_upstream_at_date.sh "2023-01-01"
./find_upstream_at_date.sh "2023-06-01"
./find_upstream_at_date.sh "2023-12-01"
```

### Option 3: Compare with Current Upstream

If unsure, compare with current upstream. The list will include:
- Your changes
- ALL changes upstream made after your last merge

```bash
./compare_with_upstream.sh
# (no argument = compare with current upstream master)
```

Then you can manually review which changes are yours vs upstream's new additions.

## Understanding the Results

### YOUR_CHANGES.md Structure

```markdown
# Your Fork Changes vs Upstream

**Upstream Commit**: abc123def456
**Upstream Date**: 2023-06-15 10:30:00
**Upstream Ref Used**: v21.3

## Summary
- New files added: 42
- Files modified: 15
- Files deleted: 3

## New Files Added to Fork
(These are files you created)

## Modified Files
(These show your modifications with diffs)

## Files Deleted from Fork
(These are files from upstream you removed)
```

### Interpreting Results

- **New files added**: Files you created that weren't in upstream at that version
- **Files modified**: Files where you changed the content
- **Files deleted**: Files that existed in upstream but you removed

## Tips

1. **Start with a date** if you remember approximately when you last merged
2. **Use tags** (v21.3, v22.1, etc.) if you know which version you based your work on
3. **The more specific** the upstream version, the more accurate your change list
4. **Review the generated diffs** to verify they're all your changes

## Troubleshooting

### "Could not checkout 'v21.3'"

The tag might not exist. List available tags:
```bash
git ls-remote --tags https://github.com/john30/ebusd-configuration.git | tail -20
```

### "No commit found before [date]"

Try an earlier date or use the first commit:
```bash
./find_upstream_at_date.sh "2020-01-01"
```

### Comparison takes too long

The script compares every file. For 509 files, this takes 1-2 minutes. Be patient!

## Next Steps

After generating YOUR_CHANGES.md:

1. **Review the list** to verify it captures your changes
2. **Document your changes** in your own format if needed
3. **Use this list** to adapt your changes to the new upstream structure
4. **Keep the script** for future comparisons when adapting to new upstream versions

---

**Need help?** Check:
- README_COMPARISON.md - Quick start guide
- FORK_CHANGES.md - Detailed documentation
- This file - Step-by-step process
