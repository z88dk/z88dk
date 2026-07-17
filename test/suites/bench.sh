#!/bin/bash
#
# bench.sh — bytes+ticks comparison across compiler/mode combos for one
# benchmark suite (intbench, md5, etc).
#
# Usage:  bash bench.sh <suite-dir>
# Example: bash bench.sh intbench
#          bash bench.sh md5
#
# Compares the suite's .c source built with sccz80 (default + -O0),
# and 80cc (default, --opt-disable=cse-synth, --opt-disable=all),
# all targeting z80. Reports the resulting .bin size and z88dk-ticks
# cycle count for each build, printed as a markdown table. Useful for
# tracking the speed/size trade-off as we land optimisations and for
# verifying the 80cc default path stays ahead of cse-synth-disabled
# (post-#261 the cost-model gate makes them converge for int-heavy
# benchmarks).

set -e

if [ -z "$1" ]; then
    echo "usage: $0 <suite-dir>" >&2
    exit 1
fi

SUITE_DIR="$1"
if [ ! -d "$SUITE_DIR" ]; then
    echo "$0: no such directory: $SUITE_DIR" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SUITE_ABS="$(cd "$SUITE_DIR" && pwd)"
SUITE_NAME="$(basename "$SUITE_ABS")"
FRAMEWORK="$SCRIPT_DIR/../framework"
MACHINE_CMD="z88dk-ticks -w 30 -b msx"

# Build configs: "label|zcc arguments (without -o/-m, the script appends those)"
BUILDS=(
  "sccz80 default|zcc +test -compiler=sccz80 -vn"
  "sccz80 -O0|zcc +test -compiler=sccz80 -O0 -vn"
  "sdcc default|zcc +test -compiler=sdcc -vn"
  "ez80clang default|zcc +test -compiler=ez80clang -vn"
  "80cc default|zcc +test -compiler=80cc -vn"
  "80cc -fframe-pointer|zcc +test -compiler=80cc -Cc-fframe-pointer -vn"
  "80cc --opt-disable=cse-synth|zcc +test -compiler=80cc -Cc--opt-disable=cse-synth -vn"
  "80cc --opt-disable=all|zcc +test -compiler=80cc -Cc--opt-disable=all -vn"
)

cd "$SUITE_ABS"
SRCS=$(ls *.c)
SOURCES="$FRAMEWORK/test.c $SRCS"
CFLAGS="-DNO_LOG_RUNNING -DNO_LOG_PASSED -I$FRAMEWORK"

clean_artifacts() {
    rm -f bench.bin bench.map *.o "$FRAMEWORK"/*.o zcc_opt.def 2>/dev/null || true
}

ROWS=()
BASELINE_BYTES=""
BASELINE_TICKS=""

for entry in "${BUILDS[@]}"; do
    label="${entry%%|*}"
    cmd="${entry#*|}"
    clean_artifacts
    if ! out=$($cmd $CFLAGS $SOURCES -o bench.bin -m 2>&1); then
        ROWS+=("$label|FAIL|FAIL|")
        continue
    fi
    if [ ! -f bench.bin ]; then
        ROWS+=("$label|no-bin|no-bin|")
        continue
    fi
    bytes=$(wc -c < bench.bin | tr -d ' ')
    ticks_out=$($MACHINE_CMD bench.bin 2>&1 || true)
    ticks=$(echo "$ticks_out" | grep -oE 'Ticks: [0-9]+' | awk '{print $2}')
    [ -z "$ticks" ] && ticks="?"
    # Test framework reports "N passed, M failed" — if any failed,
    # the build is functionally wrong even if it produced a ticks
    # number. Distinguish so the table doesn't silently rank a
    # miscompile as a perf win.
    pass_status="pass"
    if echo "$ticks_out" | grep -qE '[1-9][0-9]* failed'; then
        pass_status="FAIL"
    elif ! echo "$ticks_out" | grep -qE 'passed'; then
        pass_status="?"
    fi

    # First passing row is the baseline (typically sccz80 default).
    if [ -z "$BASELINE_BYTES" ] && [ "$pass_status" = "pass" ]; then
        BASELINE_BYTES="$bytes"
        BASELINE_TICKS="$ticks"
        ratio=""
    elif [ "$ticks" = "?" ] || [ -z "$BASELINE_TICKS" ] || [ "$BASELINE_TICKS" = "?" ]; then
        ratio=""
    else
        ratio=$(awk "BEGIN { printf \"%.2fx\", $ticks / $BASELINE_TICKS }")
    fi
    ROWS+=("$label|$bytes|$ticks|$ratio|$pass_status")
done

clean_artifacts

# Markdown output.
printf "\n## %s (z80)\n\n" "$SUITE_NAME"
printf "| Build | Bytes | Ticks | vs sccz80 default | Pass |\n"
printf "|---|---:|---:|---:|:---:|\n"
for row in "${ROWS[@]}"; do
    label="${row%%|*}"; r="${row#*|}"
    bytes="${r%%|*}"; r="${r#*|}"
    ticks="${r%%|*}"; r="${r#*|}"
    ratio="${r%%|*}"; pass="${r#*|}"
    # Format ticks with thousands separators for readability.
    if [ "$ticks" != "?" ] && [ "$ticks" != "FAIL" ] && [ "$ticks" != "no-bin" ]; then
        ticks_fmt=$(printf "%'d" "$ticks" 2>/dev/null || echo "$ticks")
    else
        ticks_fmt="$ticks"
    fi
    if [ "$bytes" != "FAIL" ] && [ "$bytes" != "no-bin" ]; then
        bytes_fmt=$(printf "%'d" "$bytes" 2>/dev/null || echo "$bytes")
    else
        bytes_fmt="$bytes"
    fi
    case "$pass" in
        pass) pass_fmt="ok" ;;
        FAIL) pass_fmt="**FAIL**" ;;
        *)    pass_fmt="$pass" ;;
    esac
    printf "| %s | %s | %s | %s | %s |\n" "$label" "$bytes_fmt" "$ticks_fmt" "$ratio" "$pass_fmt"
done
echo
