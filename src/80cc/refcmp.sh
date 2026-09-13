#!/bin/bash
# refcmp.sh <refdir> — rebuild the same set and diff against the reference.
# Filters the per-run header (timestamp / module name) that always differs.
SD=$(mktemp -d)
bash /workspaces/z88dk/src/80cc/refgen.sh "$SD" >/dev/null
n=0; bad=0
for f in "$1"/*.asm; do
  b=$(basename "$f"); n=$((n+1))
  if ! diff -q <(grep -v 'Module compile time' "$f") \
                <(grep -v 'Module compile time' "$SD/$b" 2>/dev/null) >/dev/null 2>&1; then
    bad=$((bad+1)); echo "  DIFFERS: $b"
  fi
done
echo "compared $n asm files, differing: $bad"
rm -rf "$SD"
[ "$bad" = 0 ]
