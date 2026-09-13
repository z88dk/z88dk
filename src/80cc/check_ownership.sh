#!/bin/bash
# Checks the allocation-ownership invariant mechanically (DESIGN_INDEX.md):
#
#   1. Only ir_alloc.c WRITES vreg_to_phys / home_lo / home_hi.
#   2. Only ir_alloc.c READS them by index. Everywhere else asks
#      ir_home_assigned (whole-function) or ir_home_at (at a point), so a
#      future ranged home cannot be silently ignored by a point decision.
#
# ir.c is exempt: it owns the Func struct and dumps it raw, below ir_alloc.
# Run from src/80cc. Exits non-zero and prints the offending lines.
cd "$(dirname "$0")" || exit 2
FILES=$(ls ir_lower.c ir_slots.c ir_opt.c ir_analysis.c ir_build.c ir_match.c *.inc.c 2>/dev/null)
rc=0

w=$(grep -n -E '(vreg_to_phys|home_lo|home_hi)\[[^]]*\][[:space:]]*=[^=]' $FILES 2>/dev/null)
if [ -n "$w" ]; then
  echo "FAIL: allocation state written outside ir_alloc.c:"; echo "$w"; rc=1
fi

m=$(grep -n -E 'memcpy\([^,]*(vreg_to_phys|home_lo|home_hi)' $FILES 2>/dev/null)
if [ -n "$m" ]; then
  echo "FAIL: allocation state copied over outside ir_alloc.c:"; echo "$m"; rc=1
fi

r=$(grep -n -E -- '->(vreg_to_phys|home_lo|home_hi)\[' $FILES 2>/dev/null)
if [ -n "$r" ]; then
  echo "FAIL: allocation state read by index outside ir_alloc.c"
  echo "      (use ir_home_assigned for a scan, ir_home_at at a point):"
  echo "$r"; rc=1
fi

[ $rc = 0 ] && echo "ownership OK: ir_alloc.c is the only writer and the only indexed reader"
exit $rc
