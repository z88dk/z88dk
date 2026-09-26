#!/bin/sh
# Run the whole llvmz80 integration suite against every supported C library.
#
# The SAME testcases run under each clib via run_all.sh's TEST_CLIB selector
# (classic = the supported path; newlib_iy/newlib_ix = the sanctioned clang
# newlib route; sdcc_iy/sdcc_ix = the unsupported -compiler=sdcc override).
# Classic-specific tests and known newlib gaps self-skip on the newlib runs
# (see run_all.sh's newlib_skip_reason); everything else must pass on both.
#
# Usage:  [LLVMZ80EXE=... NTVCM=...] ./run_matrix.sh [clib ...]
#   default clibs: classic newlib_iy
set -e
DIR=$(cd "$(dirname "$0")" && pwd)

CLIBS="${*:-classic newlib_iy}"
rc=0
for clib in $CLIBS; do
    echo "################################################################"
    echo "## TEST_CLIB=$clib"
    echo "################################################################"
    if TEST_CLIB="$clib" sh "$DIR/run_all.sh"; then
        echo ">> $clib: all green"
    else
        echo ">> $clib: FAILURES"
        rc=1
    fi
    echo ""
done
exit $rc
