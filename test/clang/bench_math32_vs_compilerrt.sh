#!/bin/sh
# Reproducible benchmark: math32 vs compiler-rt, all f32 libcalls, incl. the
# -ffast-math compare variant (___cmpsf2_fast). ravn/llvm-z80 #277.
#
# This is the SCRIPT form of the numbers quoted in
# z88dk/libsrc/l/llvmz80/MATH32_BRIDGE.md (Sec. 5, Sec. 5a) and
# llvm-z80/tasks/design-2026-07-31-float32-math32-strategy.md (Sec. 9b, 9c).
# Those numbers were originally produced by ad-hoc /tmp commands that were
# cleaned up afterwards -- not reproducible. This script exists so anyone can
# regenerate (and thus re-verify) that table from scratch, and so future
# backend/bridge changes can be checked against it directly instead of
# trusting a frozen table.
#
# Method for each op:
#   math32 side:      the REAL production pipeline, `zcc +cpm
#                      -compiler=llvmz80 -mllvm -z80-float-sdcccall0
#                      -lmath32`, N=2000 loop, z88dk-ticks on the .com.
#   compiler-rt side: a standalone freestanding binary (no CP/M CRT): plain
#                      portable C compiled `--target=z80 -Os` (optionally
#                      -ffast-math) with no z88dk/-sdcccall0 flag, so clang
#                      emits the DEFAULT-ABI libcall; linked directly against
#                      the prebuilt compiler-rt .o for that op; N=2000 loop;
#                      z88dk-ticks -pc <_start> -end <_bench_halt address>.
#                      Letting clang itself lower the libcall (rather than
#                      hand-rolling the register shuffle) is deliberate: it
#                      is what a real freestanding compiler-rt caller does,
#                      and avoids any hand-written-asm ABI mismatch bugs.
#
# All operand values match the historical baseline (design doc Sec 9/9b):
# 3.14159f / 2.71828f for the two-float ops, 12345.678f for f2i, 12345 for
# i2f.
#
# Usage: PATH=<z88dk>/bin:$PATH ZCCCFG=<z88dk>/lib/config \
#        LLVMZ80EXE=<llvm-z80 build>/bin/clang \
#        LLVM_Z80_BUILD=<llvm-z80 build dir> ./bench_math32_vs_compilerrt.sh
# Skips (exit 0) if the required tools aren't available.
set -e
export LC_NUMERIC=C LC_ALL=C
DIR=$(cd "$(dirname "$0")" && pwd)
BRIDGE_DIR="$DIR/../../libsrc/l/llvmz80"
MATH32_DIR="$DIR/../../libsrc"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
command -v z88dk-ticks >/dev/null 2>&1 || { echo "SKIP: z88dk-ticks not on PATH"; exit 0; }
LLVM_Z80_BUILD=${LLVM_Z80_BUILD:-}
if [ -z "$LLVM_Z80_BUILD" ]; then
	for candidate in \
		"/Users/ravn/z80/llvm-z80/build-macos" \
		"/Users/ravn/z80/llvm-z80/build" \
		"/home/ravn/z80/llvm-z80/build-macos" \
		"/home/ravn/z80/llvm-z80/build"; do
		if [ -x "$candidate/bin/clang" ] && "$candidate/bin/clang" --version 2>&1 | grep -q "z80\|Z80"; then
			LLVM_Z80_BUILD="$candidate"
			break
		fi
	done
fi
[ -n "$LLVM_Z80_BUILD" ] || { echo "SKIP: set LLVM_Z80_BUILD to the llvm-z80 build dir"; exit 0; }
CLANG="$LLVM_Z80_BUILD/bin/clang"
LLD="$LLVM_Z80_BUILD/bin/ld.lld"
OBJCOPY="$LLVM_Z80_BUILD/bin/llvm-objcopy"
OBJDUMP="$LLVM_Z80_BUILD/bin/llvm-objdump"
RT_LIB="$LLVM_Z80_BUILD/lib/z80/elf-runtime/builtins"
for f in "$CLANG" "$LLD" "$OBJCOPY" "$OBJDUMP"; do
	[ -x "$f" ] || { echo "SKIP: missing $f"; exit 0; }
done

WORK=/tmp/benchkeep; mkdir -p "$WORK"
# trap disabled for debug

# --- math32 side: real zcc pipeline, N=2000 loop -----------------------------
# $1 = op label, $2 = C loop body, $3 = extra zcc flags (e.g. -ffast-math).
# Always links all 3 llvmz80 math32 bridge files that are self-contained
# (no INCLUDE dependency) -- __addsf3 (add/sub/mul/div), __cmpsf2 (compare),
# __floatsisf (f2i/i2f) -- since the shared loop template's `(int)rf` return
# cast alone drags in ___fixsfsi regardless of which op is under test.
bench_math32() {
	label=$1; body=$2; extra=$3
	src="$WORK/m32_$label.c"
	cat >"$src" <<-EOF
	static volatile float a = 3.14159f, b = 2.71828f;
	static volatile float fa = 12345.678f;
	static volatile int ia = 12345;
	int main(void) {
	    unsigned i;
	    volatile int r = 0;
	    volatile float rf = 0;
	    for (i = 0; i < 2000; i++) { $body }
	    return r + (int)rf;
	}
	EOF
	if ! zcc +cpm -compiler=llvmz80 -O2 $extra -create-app \
		-mllvm -z80-float-sdcccall0 \
		-L"$MATH32_DIR" -lmath32 \
		-o "$WORK/m32_$label" "$BRIDGE_DIR/__addsf3.asm" "$BRIDGE_DIR/__cmpsf2.asm" "$BRIDGE_DIR/__floatsisf.asm" "$src" >"$WORK/m32_$label.log" 2>&1; then
		echo "BUILD FAILED ($label, math32):"; cat "$WORK/m32_$label.log"; exit 1
	fi
	total=$(z88dk-ticks "$WORK/m32_$label.com" 2>/dev/null | tail -1)
	echo "$total"
}

# --- compiler-rt side: standalone freestanding binary, N=2000 loop ----------
# $1 = op label, $2 = C loop body, $3 = extra clang flags, $4 = obj files
bench_compilerrt() {
	label=$1; body=$2; extra=$3; objs=$4
	src="$WORK/rt_$label.c"
	cat >"$src" <<-EOF
	static volatile float a = 3.14159f, b = 2.71828f;
	static volatile float fa = 12345.678f;
	static volatile int ia = 12345;
	volatile int r;
	volatile float rf;
	__attribute__((noreturn, noinline)) void bench_halt(void) {
	    for (;;) { __asm__ volatile("halt"); }
	}
	void _start(void) {
	    __asm__ volatile("ld sp, #0xF000");
	    for (unsigned i = 0; i < 2000; i++) { $body }
	    bench_halt();
	}
	EOF
	obj="$WORK/rt_$label.o"
	elf="$WORK/rt_$label.elf"
	bin="$WORK/rt_$label.bin"
	"$CLANG" --target=z80 -Os $extra -ffreestanding -nostdlib -fno-builtin \
		-c "$src" -o "$obj" 2>"$WORK/rt_$label.log" \
		|| { echo "COMPILE FAILED ($label, compiler-rt):"; cat "$WORK/rt_$label.log"; exit 1; }
	# shellcheck disable=SC2086
	"$LLD" -e __start -Ttext=0 "$obj" $objs -o "$elf" 2>"$WORK/rt_$label.link.log" \
		|| { echo "LINK FAILED ($label, compiler-rt):"; cat "$WORK/rt_$label.link.log"; exit 1; }
	"$OBJCOPY" -O binary "$elf" "$bin"
	start=$("$OBJDUMP" -t "$elf" | awk '/ __start$/{print $1}')
	halt=$("$OBJDUMP" -t "$elf" | awk '/ _bench_halt$/{print $1}')
	total=$(z88dk-ticks -pc "0x$start" -end "0x$halt" "$bin" 2>/dev/null | tail -1)
	echo "$total"
}

# op, math32 body, compiler-rt body, compiler-rt objs (space-separated),
# extra math32 flags, extra compiler-rt flags
run_op() {
	label=$1; m32body=$2; rtbody=$3; rtobjs=$4; extra_m32=$5; extra_rt=$6
	t_m32=$(bench_math32 "$label" "$m32body" "$extra_m32")
	t_rt=$(bench_compilerrt "$label" "$rtbody" "$extra_rt" "$rtobjs")
	printf "%-16s math32=%-10s (%.1f T/call)  compiler-rt=%-10s (%.1f T/call)\n" \
		"$label" "$t_m32" "$(echo "$t_m32 / 2000" | bc -l)" \
		"$t_rt" "$(echo "$t_rt / 2000" | bc -l)"
}

echo "=== math32 vs compiler-rt, N=2000 loop, z88dk-ticks ==="
# Fixed operands every iteration (assignment, not +=) -- accumulating the
# result would feed a different (drifting) operand into the op each pass,
# confounding the timing with math32's shift-count-depends-on-magnitude
# behaviour. Matches the original 1-instruction-body methodology (design
# doc Sec 9/9b): same op, same inputs, every call.
run_op add     'rf = a + b;'   'rf = a + b;'   "$RT_LIB/addsf3.o"
run_op sub     'rf = a - b;'   'rf = a - b;'   "$RT_LIB/addsf3.o"
run_op mul     'rf = a * b;'   'rf = a * b;'   "$RT_LIB/mulsf3.o"
run_op div     'rf = a / b;'   'rf = a / b;'   "$RT_LIB/divsf3.o"
run_op compare 'r = (a < b);'  'r = (a < b);'  "$RT_LIB/cmpsf2.o"
run_op f2i     'r = (int)fa;'  'r = (int)fa;'  "$RT_LIB/fixsfsi.o"
run_op i2f     'rf = (float)ia;' 'rf = (float)ia;' "$RT_LIB/floatsisf.o"
echo ""
echo "=== -ffast-math compare (___cmpsf2_fast) ==="
run_op compare_fast 'r = (a < b);' 'r = (a < b);' "$RT_LIB/cmpsf2.o" "-ffast-math" "-ffast-math"

echo "PASS: bench_math32_vs_compilerrt"
