#!/bin/sh
# benchcmp.sh — cross-compiler benchmark comparison for the z88dk bench suites.
#
# Compiles each benchmark with sccz80, sdcc, 80cc (fp = -frameix) and 80cc (sp)
# via the +test framework, runs it under z88dk-ticks, and prints a table of
# ticks / binary size / pass-fail. Each bench is built and run from its OWN
# directory so file-reading tests (md5 reads md5test.bin) find their inputs.
#
# Usage:  ./benchcmp.sh [-b MACH] [-w BUDGET] [bench ...]
#   -b MACH    z88dk-ticks machine (default: msx)
#   -w BUDGET  ticks cycle budget in units (default: 60)
#   bench ...  subset of the default list (dir names below)
#
# Run from test/suites/ with the repo bin on PATH and ZCCCFG set, e.g.:
#   PATH=$PWD/../../bin:$PATH ZCCCFG=$PWD/../../lib/config ./benchcmp.sh

set -u
MACH=msx
BUDGET=60
while [ $# -gt 0 ]; do
    case "$1" in
        -b) MACH=$2; shift 2 ;;
        -w) BUDGET=$2; shift 2 ;;
        --) shift; break ;;
        -*) echo "unknown flag: $1" >&2; exit 2 ;;
        *)  break ;;
    esac
done

# bench dir : source file (relative to the bench dir)
default_benches="charbench:charbench.c crcbench:crcbench.c intbench:intbench.c \
md5:md5sum.c ptrbench:ptrbench.c sieve:sieve.c rle:rle_encode.c \
sortbench:sortbench.c queenbench:queenbench.c \
searchbench:searchbench.c \
switchbench:switchbench.c"

if [ $# -gt 0 ]; then
    sel=""
    for b in "$@"; do
        for e in $default_benches; do
            case "$e" in "$b":*) sel="$sel $e" ;; esac
        done
    done
    benches=$sel
else
    benches=$default_benches
fi

# config label : extra zcc flags
configs="sccz80:-compiler=sccz80 sdcc:-compiler=sdcc \
80cc-fp:-compiler=80cc_-Cc-frameix 80cc-sp:-compiler=80cc"

CFLAGS="-I../../framework -DNO_LOG_RUNNING -DNO_LOG_PASSED"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# header
printf '%-11s' "bench"
for c in $configs; do printf ' | %-22s' "${c%%:*}"; done
printf '\n'
printf '%-11s' "-----------"
for c in $configs; do printf ' | %-22s' "----------------------"; done
printf '\n'

for e in $benches; do
    dir=${e%%:*}; src=${e#*:}
    [ -d "$dir" ] || continue
    printf '%-11s' "$dir"
    for c in $configs; do
        label=${c%%:*}; flags=$(echo "${c#*:}" | tr '_' ' ')
        out="$tmp/$dir-$label.bin"
        ( cd "$dir" && zcc +test -vn $flags $CFLAGS ../../framework/test.c "$src" \
            -o "$out" -m ) >/dev/null 2>&1
        if [ ! -f "$out" ]; then
            printf ' | %-22s' "build-fail"
            continue
        fi
        res=$( cd "$dir" && z88dk-ticks -w "$BUDGET" -b "$MACH" "$out" 2>&1 )
        ticks=$(echo "$res" | grep -oE 'Ticks: [0-9]+' | grep -oE '[0-9]+')
        fail=$(echo "$res"  | grep -oE '[0-9]+ failed' | grep -oE '[0-9]+' | head -1)
        size=$(wc -c < "$out" | tr -d ' ')
        [ -z "$ticks" ] && ticks="?"
        tag=""
        [ -n "${fail:-}" ] && [ "$fail" != "0" ] && tag=" FAIL"
        # ticks in millions, 2 d.p.
        m=$(awk "BEGIN{if(\"$ticks\"==\"?\")print\"?\";else printf \"%.2fM\", $ticks/1000000}")
        printf ' | %-22s' "$m/${size}B$tag"
    done
    printf '\n'
done
