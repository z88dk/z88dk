#!/bin/sh
# Red-green runtime test covering EVERY routine in the libsrc/l/llvmz80/ integer
# runtime bridge (bridges to the shared l_* math cores).
#
# Which compiler-rt name the backend emits depends on the opt level and code
# shape, so this builds + runs runtime_intdiv.c at -O2, -O3 and
# -O2 --opt-code-size and, for
# each, (a) asserts the link resolved, (b) asserts the map references the
# bridge symbols that opt level is expected to emit (coverage proof), and
# (c) runs it in ntvcm and checks every computed value.
#
# GREEN: links + prints correct results at all opt levels.
# RED  : a missing bridge symbol -> "undefined symbol: ___...", or a wrong-ABI
#        bridge -> links but prints wrong numbers.  Both are caught below.
#        (Before the _fast + __divmodsi4/__udivmodsi4 bridges existed, the -O3
#        link failed on ___divhi3_fast / ___divmodsi4.)
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_intdiv.sh
# Requires zcc (llvmz80 configured) + an ntvcm CP/M emulator (env NTVCM, else
# `ntvcm` on PATH).  Skips (exit 0) if either is unavailable.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_intdiv.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

# Host-computed expectations (identical at every opt level):
#   16-bit: 1234*57=70338->4802; 1234/57=21; 1234%57=37;
#           50000*7=350000->22320; 50000/7=7142; 50000%7=6
#   32-bit: 1000000/7=142857 rem 1; 4000000000/13=307692307 rem 9
#   8-bit : 200/7=28; 200%7=4
EXP_H="h 4802 21 37 22320 7142 6"
EXP_L="l 142857 1 307692307 9"
EXP_F="f 142857 1 307692307 9"
EXP_Q="q 28 4"

# run_at <opt> <expected syms...> [ -- <forbidden syms...> ]
# Expected syms must be CALLED in the generated asm (emission/coverage proof);
# forbidden syms must NOT be called (used to prove -O2 does NOT reach the
# -O3-only _fast cores).  We grep the .s call sites -- not the .map -- because
# each bridge object exports several PUBLIC aliases (e.g. ___divhi3 AND
# ___divhi3_fast live in the same module), so a name can be DEFINED in the map
# without being CALLED.  Symbols are the exact asm spelling (leading ___) and
# matched with -wF so ___divhi3 does not spuriously match ___divhi3_fast.
run_at() {
	OPT="$1"; shift
	EXPECT_SYMS=""; FORBID_SYMS=""; _phase=expect
	for a in "$@"; do
		if [ "$a" = "--" ]; then _phase=forbid; continue; fi
		if [ "$_phase" = expect ]; then EXPECT_SYMS="$EXPECT_SYMS $a"; else FORBID_SYMS="$FORBID_SYMS $a"; fi
	done
	B="$WORK/rt_$(echo "$OPT" | tr -d ' -')"

	# Emit asm for the call-site (emission) assertions.
	zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} $OPT -S -o "$B.s" "$SRC" >"$B.slog" 2>&1 \
		|| { echo "--- asm log ($OPT) ---"; cat "$B.slog"; fail "$OPT: zcc -S failed"; }

	# Link + build the runnable .com (also proves every helper resolves).
	if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} $OPT -create-app -o "$B" "$SRC" -m >"$B.log" 2>&1; then
		echo "--- build log ($OPT) ---"; cat "$B.log"
		if grep -qi 'undefined symbol' "$B.log"; then
			fail "$OPT: link failed with undefined runtime helper (bridge symbol missing from z80_crt0.lib?)"
		fi
		fail "$OPT: zcc build failed"
	fi
	[ -f "$B.com" ] || fail "$OPT: no .com produced"

	# (b) coverage proof: each expected helper must be CALLED in the asm.
	for sym in $EXPECT_SYMS; do
		grep -wF "$sym" "$B.s" >/dev/null || fail "$OPT: expected helper $sym not emitted (coverage gap)"
	done
	# (b') negative proof: forbidden helpers must NOT be called (opt mapping).
	for sym in $FORBID_SYMS; do
		grep -wF "$sym" "$B.s" >/dev/null && fail "$OPT: forbidden helper $sym emitted (zcc -O<n> not passed through to clang?)"
	done

	# (c) value check.
	OUT=$("$NTVCM" "$B.com" 2>/dev/null | tr -d '\r')
	echo "$OUT" | grep -qF "$EXP_H" || fail "$OPT: 16-bit wrong. got: $(echo "$OUT" | sed -n 1p) want: $EXP_H"
	echo "$OUT" | grep -qF "$EXP_L" || fail "$OPT: 32-bit separate wrong. got: $(echo "$OUT" | sed -n 2p) want: $EXP_L"
	echo "$OUT" | grep -qF "$EXP_F" || fail "$OPT: 32-bit fused divmod wrong. got: $(echo "$OUT" | sed -n 3p) want: $EXP_F"
	echo "$OUT" | grep -qF "$EXP_Q" || fail "$OPT: 8-bit wrong. got: $(echo "$OUT" | sed -n 4p) want: $EXP_Q"
	echo "  ok $OPT (symbols: $EXPECT_SYMS)"
}

# zcc now passes its -O<n> straight through to clang (-O2 -> clang -O2, -O3 ->
# clang -O3; --opt-code-size -> clang -Oz).  Each level emits a different set of
# bridge names, so exercise all three for full coverage:
#   -O2 (clang -O2)  : plain 16-bit cores + separate/fused 32-bit.
#   -O3 (clang -O3)  : plain 16-bit cores + separate/fused 32-bit.
#   --opt-code-size  : plain 16-bit cores + the 8-bit qi cores + fused 32-bit.
run_at "-O2" ___divhi3 ___udivhi3 ___modhi3 ___umodhi3 ___mulhi3 ___divmodsi4 ___udivmodsi4 ___divsi3 ___modsi3 ___udivsi3 ___umodsi3 \
	-- ___divhi3_fast ___udivhi3_fast ___modhi3_fast ___umodhi3_fast
run_at "-O3" ___divhi3_fast ___udivhi3_fast ___modhi3_fast ___umodhi3_fast ___mulhi3 ___divmodsi4 ___udivmodsi4 ___divsi3 ___modsi3 ___udivsi3 ___umodsi3 \
	-- ___divhi3 ___udivhi3 ___modhi3 ___umodhi3
run_at "-O2 --opt-code-size" ___divhi3 ___udivhi3 ___modhi3 ___umodhi3 ___mulhi3 ___udivqi3 ___umodqi3 ___divmodsi4 ___udivmodsi4 ___divsi3 ___modsi3 ___udivsi3 ___umodsi3

echo "PASS: llvmz80 integer runtime bridge (16/8/32-bit, fast + fused) links and computes correctly at -O2, -O3 and --opt-code-size"
