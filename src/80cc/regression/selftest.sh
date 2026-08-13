#!/bin/bash
# 80cc unit-level selftest: builds ir_selftest in src/80cc and runs it.
# Exits non-zero on any FAIL line. Skips cleanly (rc=2) if the prebuilt
# 80cc objects aren't available.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
WORK="${WORK:-/tmp/sccz80_reg_selftest}"
mkdir -p "$WORK"

# Need the IR object files from the standard build. ir_match.o (the
# table-driven fusion engine) and ir_slots.o (ir_assign_slots) were added
# after this list was first written — ir_selftest.c and ir_lower.c now
# reference symbols from both, so the link fails without them.
for o in ir.o ir_analysis.o ir_lower.o ir_alloc.o ir_opt.o ir_match.o ir_slots.o; do
    if [ ! -f "$ROOT/$o" ]; then
        echo "selftest: $o not built — run 'make' in src/80cc first; skipping"
        exit 2
    fi
done

BIN="$WORK/ir_selftest"
cc -I"$ROOT/../common" -I"$ROOT/../../ext/uthash/src/" -g -std=gnu11 \
   -o "$BIN" "$ROOT/ir_selftest.c" \
   "$ROOT/ir.o" "$ROOT/ir_analysis.o" "$ROOT/ir_lower.o" "$ROOT/ir_alloc.o" \
   "$ROOT/ir_opt.o" "$ROOT/ir_match.o" "$ROOT/ir_slots.o" \
   2>"$WORK/build.log"
if [ $? -ne 0 ]; then
    echo "selftest: build failed:"
    cat "$WORK/build.log"
    exit 1
fi

OUT="$WORK/run.log"
if ! "$BIN" >"$OUT" 2>&1; then
    echo "selftest: ir_selftest exit non-zero:"
    cat "$OUT"
    exit 1
fi

if grep -q '^FAIL\|^  FAIL' "$OUT"; then
    echo "selftest: FAIL lines in output:"
    grep -E '^FAIL|^  FAIL' "$OUT"
    exit 1
fi

if ! grep -q 'ALL CHECKS PASSED' "$OUT"; then
    echo "selftest: missing final 'ALL CHECKS PASSED' marker:"
    tail -20 "$OUT"
    exit 1
fi

echo "selftest: ok"
