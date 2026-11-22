#!/bin/sh
# The N: records, and the E: records of the globals and file statics, that sccz80
# and 80cc write for enums_a.c are the same and are enums_a.records (the E: records
# of locals and parameters carry frame offsets, and 80cc writes none for some).
#
# usage: check_enumrecs.sh <asm from -a -debug> <label>
set -u

got=$(grep -E '^; (N:|E:[GF])' "$1" | LC_ALL=C sort -u)
if [ "$got" != "$(cat enums_a.records)" ]; then
    echo "  enum records differ from enums_a.records [$2]:"
    echo "$got" | diff enums_a.records - | sed 's/^/    /'
    echo "debuginfo enumrecs FAIL ($2)"
    exit 1
fi
echo "debuginfo enumrecs OK ($2)"
