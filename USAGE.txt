===========================================
HOW TO GENERATE YOUR FORK CHANGES LIST
===========================================

Since upstream has changed significantly since your last merge, you need to:

1. Find the upstream version you last merged from
2. Compare against THAT version (not current upstream)

QUICK START:
------------

If you know your last merge date (e.g., June 15, 2023):

  ./find_upstream_at_date.sh "2023-06-15"
  
This will output a command like:

  ./compare_with_upstream.sh v21.3

Run that command to generate YOUR_CHANGES.md

AVAILABLE GUIDES:
-----------------

- STEP_BY_STEP.md     - Complete walkthrough
- README_COMPARISON.md - Quick reference
- FORK_CHANGES.md      - Detailed documentation

SCRIPTS:
--------

- find_upstream_at_date.sh - Find upstream commit at specific date
- compare_with_upstream.sh - Generate comparison report

EXAMPLES:
---------

# Find upstream at specific date
./find_upstream_at_date.sh "2023-06-15"

# Compare against specific tag
./compare_with_upstream.sh v21.3

# Compare against specific commit
./compare_with_upstream.sh abc123def

# Compare against current upstream (shows ALL differences)
./compare_with_upstream.sh

OUTPUT:
-------

The script generates YOUR_CHANGES.md containing:
- All files you added
- All files you modified (with diffs)
- All files you deleted
- Summary statistics

===========================================
