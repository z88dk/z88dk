#!/bin/bash
# run-matrix.sh — behavioural correctness matrix for the 80cc backend.
#
# Runs each suite in BOTH frame modes — sp (default) and fp (IX frame pointer,
# via the make.config FP=1 hook) — building and running every CPU target the
# suite's Makefile defines (each target compiles AND runs under z88dk-ticks with
# the right -m, and make exits non-zero on any failed assertion). This gives the
# fp residency paths the same behavioural coverage as sp — the safety net the
# register allocator work needs, and the coverage gap that let fp/CPU-specific
# residency bugs slip past a z80-only differential.
#
# Usage:  bash run-matrix.sh [suite ...]
#   env:  COMPILER (default 80cc), MODES (default "sp fp")
#
# Exits non-zero if any suite/mode fails.

set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$HERE"

export ZCCCFG="${ZCCCFG:-$(cd "$HERE/../../lib/config" && pwd)}"
export PATH="$(cd "$HERE/../../bin" && pwd):$PATH"

COMPILER="${COMPILER:-80cc}"
MODES="${MODES:-sp fp}"

# Default suite set: IR-pattern (long_ir), behavioural libc (sccz80/stdlib/
# ctype/string/stdio), and the residency-heavy benches.
default_suites="long_ir sccz80 stdlib ctype string stdio \
                sieve charbench crcbench intbench listbench hashbench \
                matrixbench structbench recordbench vecbench fixedbench \
                strbench histbench lexbench sortbench queenbench searchbench"
suites=("$@"); [ ${#suites[@]} -eq 0 ] && suites=($default_suites)

fails=()
for s in "${suites[@]}"; do
    [ -d "$s" ] || { echo "skip $s (no dir)"; continue; }
    for m in $MODES; do
        fp=""; [ "$m" = fp ] && fp="FP=1"
        ( cd "$s" && make -s clean >/dev/null 2>&1; \
          make $fp COMPILER="$COMPILER" ) >"/tmp/mtx_${s}_${m}.log" 2>&1
        if [ $? -eq 0 ]; then
            printf '  %-14s %-3s  OK\n' "$s" "$m"
        else
            printf '  %-14s %-3s  FAIL  (see /tmp/mtx_%s_%s.log)\n' "$s" "$m" "$s" "$m"
            grep -iE "failed|error:" "/tmp/mtx_${s}_${m}.log" | grep -viE "0 failed" | head -3 | sed 's/^/      /'
            fails+=("$s/$m")
        fi
    done
done

echo
if [ ${#fails[@]} -gt 0 ]; then
    echo "MATRIX FAIL: ${fails[*]}" >&2
    exit 1
fi
echo "run-matrix: all suites passed (modes: $MODES, compiler: $COMPILER)"
