#!/bin/sh
# Master runner for the ravn/llvm-z80 + z88dk integration test suite.
#
# Auto-detects LLVMZ80EXE and NTVCM from environment or well-known paths,
# then runs every *.sh in this directory (except itself).
#
# Exit code: 0 if all tests PASS or SKIP, 1 if any FAILs.
#
# Usage (all vars optional if binaries are findable):
#   LLVMZ80EXE=/path/to/clang NTVCM=/path/to/ntvcm ./run_all.sh
set -e

DIR=$(cd "$(dirname "$0")" && pwd)
SELF=$(basename "$0")

# ---- locate LLVMZ80EXE ----
if [ -z "$LLVMZ80EXE" ]; then
    for candidate in \
        "/Users/ravn/z80/llvm-z80/build-macos/bin/clang" \
        "/home/ravn/z80/llvm-z80/build/bin/clang" \
        "$(command -v clang 2>/dev/null)"; do
        if [ -x "$candidate" ] && "$candidate" --version 2>&1 | grep -q "z80\|Z80"; then
            LLVMZ80EXE="$candidate"
            break
        fi
    done
fi
if [ -z "$LLVMZ80EXE" ]; then
    echo "ERROR: cannot find ravn/llvm-z80 clang; set LLVMZ80EXE"
    exit 1
fi
export LLVMZ80EXE

# ---- locate zcc (z88dk) ----
if [ -z "$ZCCCFG" ]; then
    # Derive from LLVMZ80EXE path: go up from bin/ to find lib/config/
    Z88DK_ROOT=$(dirname "$LLVMZ80EXE")
    Z88DK_ROOT=$(cd "$Z88DK_ROOT/.." 2>/dev/null && pwd)
    # Try parent directories
    for d in "$Z88DK_ROOT" "$(dirname "$Z88DK_ROOT")" "/Users/ravn/z80/z88dk" "/home/ravn/z80/z88dk"; do
        if [ -f "$d/lib/config/cpm.cfg" ]; then
            ZCCCFG="$d/lib/config/"
            PATH="$d/bin:$PATH"
            break
        fi
    done
fi
if [ -z "$ZCCCFG" ]; then
    echo "ERROR: cannot find z88dk; set ZCCCFG"
    exit 1
fi
export ZCCCFG
export PATH

# ---- locate NTVCM ----
if [ -z "$NTVCM" ]; then
    for candidate in \
        "/Users/ravn/z80/ntvcm/ntvcm" \
        "/home/ravn/z80/ntvcm/ntvcm" \
        "$(command -v ntvcm 2>/dev/null)"; do
        if [ -x "$candidate" ]; then
            NTVCM="$candidate"
            break
        fi
    done
fi
export NTVCM

# ---- select the C library the suite builds against ----
# TEST_CLIB picks which z88dk clib every test links.  The same testcases run
# unchanged against each; each test appends $ZCC_CLIB to its `zcc` line.
#   classic   (default) -> the classic clib (-clib=default), the supported path
#   newlib_iy           -> newlib via -compiler=llvmz80 (SANCTIONED clang route,
#                          Phase C): clang -E preprocesses _DEVELOPMENT headers
#                          with -D__LLVMZ80, no z88dk-ucpp -D__SDCC choke
#   newlib_ix           -> same, IX/IY free marker (links the same sdcc_ix lib)
#   sdcc_iy / sdcc_ix   -> UNSUPPORTED override: -clib=sdcc_iy -compiler=llvmz80
#                          (the sdcc CLIB line forces -compiler=sdcc, so the
#                          ucpp -D__SDCC pass runs and __smallc/__attribute__
#                          sources cannot compile).  Kept for A/B only.
# See tasks/plan-newlib-llvmz80-support-2026-07-22.md.  Tests that are specific
# to the classic clib self-SKIP when TEST_CLIB is a newlib variant (they read
# $TEST_CLIB).
TEST_CLIB=${TEST_CLIB:-classic}
case "$TEST_CLIB" in
    classic)    ZCC_CLIB="" ;;
    newlib_iy)  ZCC_CLIB="-clib=newlib_iy" ;;
    newlib_ix)  ZCC_CLIB="-clib=newlib_ix" ;;
    sdcc_iy)    ZCC_CLIB="-clib=sdcc_iy" ;;
    sdcc_ix)    ZCC_CLIB="-clib=sdcc_ix" ;;
    *) echo "ERROR: unknown TEST_CLIB=$TEST_CLIB (classic|newlib_iy|newlib_ix|sdcc_iy|sdcc_ix)"; exit 1 ;;
esac
export TEST_CLIB ZCC_CLIB

echo "=== z88dk llvmz80 integration tests ==="
echo "  LLVMZ80EXE : $LLVMZ80EXE"
echo "  ZCCCFG     : $ZCCCFG"
echo "  NTVCM      : ${NTVCM:-not found (tests that need it will SKIP)}"
echo "  TEST_CLIB  : $TEST_CLIB ${ZCC_CLIB:+($ZCC_CLIB)}"
echo ""

PASS=0; FAIL=0; SKIP=0; XFAIL=0; XPASS=0

# ---- per-test watchdog ----------------------------------------------------
# Each test builds a .com and runs it under ntvcm.  A miscompiled/looping
# binary makes ntvcm spin forever, and since the tests run sequentially with
# no timeout that one hang blocks the whole suite (observed: a 27-minute stall
# on nontrivial_demo).  run_one() runs a test in the background and enforces a
# hard wall-clock limit; on timeout it kills the test shell AND any ntvcm it
# spawned and reports the test as a TIMEOUT (counted as FAIL).
#
# TEST_TIMEOUT is the per-test limit in seconds (default 25; a healthy test
# runs in well under a second, so this only ever fires on a genuine hang).
TEST_TIMEOUT=${TEST_TIMEOUT:-25}

# kill_tree <signal> <pid>: terminate the test shell and only its descendants.
# `ntvcm` is a child of the shell launched below; targeting the PID tree avoids
# terminating an unrelated emulator that may be running outside this suite.
kill_tree() {
    _signal="$1"; _pid="$2"
    if _children=$(pgrep -P "$_pid" 2>/dev/null); then
        for _child in $_children; do
            kill_tree "$_signal" "$_child"
        done
    fi
    kill "$_signal" "$_pid" 2>/dev/null
}

# run_one <script> <outfile> : run the test, capturing combined output to
# <outfile>.  Returns 0 if the test finished on its own, 124 if it was killed
# for exceeding TEST_TIMEOUT.  Called from an `if` so `set -e` is suspended
# inside it (a child can exit before the terminating signal is delivered).
run_one() {
    _script="$1"; _out="$2"
    _name=$(basename "$_script")
    _limit=$TEST_TIMEOUT
    case "$_name" in
        stdlib_coverage.sh) _limit=60 ;;
    esac
    : > "$_out"
    sh "$_script" > "$_out" 2>&1 &
    _spid=$!
    _elapsed=0
    while kill -0 "$_spid" 2>/dev/null; do
        if [ "$_elapsed" -ge "$_limit" ]; then
            kill_tree -TERM "$_spid"
            sleep 1
            if kill -0 "$_spid" 2>/dev/null; then
                kill_tree -KILL "$_spid"
            fi
            wait "$_spid" 2>/dev/null
            return 124
        fi
        sleep 1
        _elapsed=$((_elapsed + 1))
    done
    wait "$_spid" 2>/dev/null
    return 0
}

# Tests that do not apply to the newlib path (classic-specific behaviour) or hit
# a known, still-unfixed newlib gap.  Skipped only when TEST_CLIB is a newlib
# variant, with a reason, so the newlib run stays green while the gaps stay
# visible.  Fix phases are in tasks/plan-newlib-llvmz80-support-2026-07-22.md.
newlib_skip_reason() {
    # Genuine gaps that remain on the SANCTIONED newlib route (newlib_iy/_ix,
    # -compiler=llvmz80) after Phase C landed the compiler.h __LLVMZ80 mapping.
    case "$1" in
        runtime_file.sh)         echo "newlib CP/M FILE* not supported (asm_target_open_p1/p2 missing -- ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_fmt.sh)   echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_rw.sh)    echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_seek.sh)  echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_seekwrite.sh) echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_rbplus.sh) echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_eof.sh)   echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_null.sh)  echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_multi.sh) echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_remove.sh)echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_fileio_rename.sh)echo "newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; return 0 ;;
        runtime_stdlib2.sh)      echo "isqrt/unbcd are classic-clib-only z88dk extensions (declared in classic include/stdlib.h, absent from newlib _DEVELOPMENT headers)"; return 0 ;;
        # (The clang integer-helper libcalls __mulhi3/__divsi3/__divmodsi4/...
        # are now provided on the newlib route by llvmz80_imath.lib -- see
        # libsrc/l/llvmz80/newlib/ -- so runtime_qsort/intdiv/long PASS.)
    esac
    # The UNSUPPORTED sdcc_iy/sdcc_ix override forces -compiler=sdcc, so a
    # z88dk-ucpp -D__SDCC pass runs first and chokes on source-level __smallc /
    # __attribute__((...)); those sources cannot even compile there.  Skip the
    # extra source-feature tests on that route only (they PASS on newlib_iy).
    case "$TEST_CLIB" in
        sdcc_iy|sdcc_ix)
            case "$1" in
                runtime_qsort.sh)   echo "sdcc_iy override: __smallc rejected by ucpp -D__SDCC pass"; return 0 ;;
                runtime_intdiv.sh)  echo "sdcc_iy override: __attribute__ rejected by ucpp -D__SDCC pass"; return 0 ;;
                runtime_attr.sh)    echo "sdcc_iy override: __attribute__ rejected by ucpp -D__SDCC pass"; return 0 ;;
                nontrivial_demo.sh) echo "sdcc_iy override: compiler-selection ICE on the ucpp path"; return 0 ;;
                runtime_stdmisc.sh) echo "sdcc_iy override: runtime output mismatch on the ucpp path"; return 0 ;;
                runtime_strerror.sh)echo "sdcc_iy override: strerror differs on the ucpp path"; return 0 ;;
                runtime_long.sh)    return 1 ;;  # passes on sdcc_iy (ucpp __SDCC routes long math)
            esac ;;
    esac
    return 1
}

# Count testable scripts up front so each line can show N/total progress.
TOTAL=0
for script in "$DIR"/*.sh; do
    _n=$(basename "$script")
    case "$_n" in "$SELF"|run_all.sh|run_matrix.sh) continue ;; esac
    TOTAL=$((TOTAL + 1))
done
DONE=0
SUITE_START=$(date +%s)

# tally : print the running score so far (continuous reporting).
tally() { printf '        tally: %d pass  %d fail  %d skip  %d xfail   (%d/%d done)\n' \
                 "$PASS" "$FAIL" "$SKIP" "$XFAIL" "$DONE" "$TOTAL"; }

for script in "$DIR"/*.sh; do
    name=$(basename "$script")
    # Skip harness scripts, not just this file: run_matrix.sh calls run_all.sh,
    # so treating it as a test would recurse infinitely (a fork bomb).
    case "$name" in
        "$SELF"|run_all.sh|run_matrix.sh) continue ;;
    esac

    if [ "$TEST_CLIB" != "classic" ]; then
        if reason=$(newlib_skip_reason "$name"); then
            DONE=$((DONE + 1))
            echo "[$DONE/$TOTAL] skip  $name (newlib: $reason)"
            SKIP=$((SKIP + 1))
            tally
            continue
        fi
    fi

    DONE=$((DONE + 1))
    # In-flight line (printed BEFORE the test runs): if a test wedges, you can
    # see which one is in flight during the up-to-TEST_TIMEOUT wait.
    echo "[$DONE/$TOTAL] run   $name ..."

    _tout=$(mktemp)
    _t0=$(date +%s)
    if run_one "$script" "$_tout"; then
        result=$(tail -1 "$_tout")
    else
        result="__TIMEOUT__"
    fi
    _dt=$(( $(date +%s) - _t0 ))
    rm -f "$_tout"

    case "$result" in
        __TIMEOUT__)
            echo "[$DONE/$TOTAL] FAIL  $name -- TIMEOUT: killed after ${TEST_TIMEOUT}s (hang)"
            FAIL=$((FAIL + 1))
            ;;
        PASS:*|PASS\ *)
            echo "[$DONE/$TOTAL] PASS  $name (${_dt}s)"
            PASS=$((PASS + 1))
            ;;
        # XFAIL: a known, documented gap that is EXPECTED to fail (e.g. a
        # deliberately-absent classic-clib function).  Ignored — not a failure.
        XFAIL:*|XFAIL\ *)
            echo "[$DONE/$TOTAL] xfail $name ($result)"
            XFAIL=$((XFAIL + 1))
            ;;
        # XPASS: an xfail test that UNEXPECTEDLY succeeded — the gap closed;
        # surface it so the xfail note can be retired.  Counts as a failure.
        XPASS:*|XPASS\ *)
            echo "[$DONE/$TOTAL] XPASS $name -- $result  (unexpected: gap closed, retire the xfail)"
            FAIL=$((FAIL + 1))
            ;;
        SKIP:*|SKIP\ *)
            echo "[$DONE/$TOTAL] skip  $name ($result)"
            SKIP=$((SKIP + 1))
            ;;
        *)
            echo "[$DONE/$TOTAL] FAIL  $name -- $result"
            FAIL=$((FAIL + 1))
            ;;
    esac
    tally
done

_suite_dt=$(( $(date +%s) - SUITE_START ))
echo ""
echo "Results: $PASS PASS, $FAIL FAIL, $SKIP SKIP, $XFAIL XFAIL  (${_suite_dt}s total, TEST_TIMEOUT=${TEST_TIMEOUT}s)"
[ "$FAIL" -eq 0 ]
