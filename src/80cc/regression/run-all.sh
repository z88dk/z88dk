#!/bin/bash
# Run every regression suite in this directory. Exits non-zero
# if any suite fails. Suite scripts that need optional tooling
# (e.g. the legacy compiler) skip themselves cleanly and don't
# count as failures.
#
# Usage: bash run-all.sh [args forwarded to each suite]
#   common env overrides: COMPILER, LEGACY_SCCZ80, Z80ASM, Z88DK_LIB,
#                          TICKS, UCPP

case "`uname -s`" in
    CYGWIN*)    exit 0 ;;
    MINGW*)    exit 0 ;;
    *)          export ZCCCFG=$CFG ;;
esac


set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$HERE/lib.sh"

# Quick env check before running anything so the user sees one
# clear error rather than four cascading ones.
reg_check_env || exit 2

# Value-based suites (compile + run under ticks, assert computed results) and
# parity/coverage checks. The old asm-pattern-match scripts (const_fold,
# cond_emit, opt_fold, loop_reversal, frameptr, dehl_cache) were retired: they
# asserted exact instruction shapes from the AST-walker era and the IR emits
# different (often better) code, so they reported false failures. Behavioural
# coverage lives in test/suites/long_ir (run under ticks across CPUs).
suites=(smoke.sh typecheck.sh far.sh compound_assign.sh selftest.sh variadic.sh ir_coverage.sh fix16.sh arith.sh)
fail_suites=()

for s in "${suites[@]}"; do
    echo "=== $s ==="
    bash "$HERE/$s" "$@"
    rc=$?
    # Exit 2 from a suite means "skipped — optional tooling missing"
    # (e.g. adv_a_parity.sh when the legacy compiler isn't available).
    # Treat that the same as success.
    if [ "$rc" -ne 0 ] && [ "$rc" -ne 2 ]; then
        fail_suites+=("$s")
    fi
    echo
done

if [ "${#fail_suites[@]}" -gt 0 ]; then
    echo "FAILED: ${fail_suites[*]}" >&2
    exit 1
fi
echo "All regression suites passed."
