#!/bin/sh
# Reproducible benchmark: code SIZE of math32 vs compiler-rt division.
# ravn/llvm-z80 #277. Companion to bench_math32_vs_compilerrt.sh (which
# measures T-states/call, not bytes).
#
# Question: div is ~2.3x faster via compiler-rt (see MATH32_BRIDGE.md Sec 5),
# but which is smaller in CODE SIZE? On a byte-constrained target (e.g. an
# RC700 2 KB PROM) that can matter as much as speed.
#
# Method: build a "baseline" program (same crt0/config, but NO float op) and
# a "div" program (one `float` division, nothing else) through each
# pipeline, then diff the linked artifact sizes. The delta isolates the
# division closure itself from fixed crt0/startup/config overhead that both
# programs pay equally.
#   math32 side:      real zcc pipeline (`+cpm -compiler=llvmz80
#                      -mllvm -z80-float-sdcccall0 -lmath32`), linked
#                      against ONLY __addsf3.asm (div routes through
#                      ___divsf3 -> cm32_sdcc_fsdiv -> m32_fsdiv, per
#                      MATH32_BRIDGE.md Sec 4); .com file size.
#   compiler-rt side:  standalone freestanding binary (no z88dk crt0),
#                      linked against the prebuilt divsf3.o; .bin file size.
# Both sides deliberately avoid any other float/int op (no (int) cast, no
# second op) so nothing but the division itself differs between baseline
# and div builds.
#
# Usage: PATH=<z88dk>/bin:$PATH ZCCCFG=<z88dk>/lib/config \
#        LLVMZ80EXE=<llvm-z80 build>/bin/clang \
#        LLVM_Z80_BUILD=<llvm-z80 build dir> \
#        ./bench_math32_vs_compilerrt_size.sh
# Skips (exit 0) if the required tools aren't available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
BRIDGE_DIR="$DIR/../../libsrc/l/llvmz80"
MATH32_DIR="$DIR/../../libsrc"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
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
RT_LIB="$LLVM_Z80_BUILD/lib/z80/elf-runtime/builtins"
for f in "$CLANG" "$LLD" "$OBJCOPY"; do
	[ -x "$f" ] || { echo "SKIP: missing $f"; exit 0; }
done

WORK=/tmp/benchsize; rm -rf "$WORK"; mkdir -p "$WORK"

# --- math32 side --------------------------------------------------------
# $1 = label, $2 = extra body (empty for baseline, one division for div).
build_math32() {
	label=$1; body=$2
	src="$WORK/m32_$label.c"
	cat >"$src" <<-EOF
	static volatile float a = 3.14159f, b = 2.71828f;
	int main(void) {
	    $body
	    return 0;
	}
	EOF
	if [ "$label" = "div" ]; then
		asmfiles="$BRIDGE_DIR/__addsf3.asm"
	else
		asmfiles=""
	fi
	# shellcheck disable=SC2086
	if ! zcc +cpm -compiler=llvmz80 -O2 -create-app \
		-mllvm -z80-float-sdcccall0 \
		-L"$MATH32_DIR" -lmath32 \
		-o "$WORK/m32_$label" $asmfiles "$src" >"$WORK/m32_$label.log" 2>&1; then
		echo "BUILD FAILED (m32 $label):"; cat "$WORK/m32_$label.log"; exit 1
	fi
	wc -c <"$WORK/m32_$label.com" | tr -d ' '
}

# --- compiler-rt side ----------------------------------------------------
# $1 = label, $2 = extra body, $3 = extra obj files to link.
build_compilerrt() {
	label=$1; body=$2; objs=$3
	src="$WORK/rt_$label.c"
	cat >"$src" <<-EOF
	static volatile float a = 3.14159f, b = 2.71828f;
	volatile float rf;
	__attribute__((noreturn, noinline)) void bench_halt(void) {
	    for (;;) { __asm__ volatile("halt"); }
	}
	void _start(void) {
	    __asm__ volatile("ld sp, #0xF000");
	    $body
	    bench_halt();
	}
	EOF
	obj="$WORK/rt_$label.o"
	elf="$WORK/rt_$label.elf"
	bin="$WORK/rt_$label.bin"
	"$CLANG" --target=z80 -Os -ffreestanding -nostdlib -fno-builtin \
		-c "$src" -o "$obj" 2>"$WORK/rt_$label.log" \
		|| { echo "COMPILE FAILED (rt $label):"; cat "$WORK/rt_$label.log"; exit 1; }
	# shellcheck disable=SC2086
	"$LLD" -e __start -Ttext=0 "$obj" $objs -o "$elf" 2>"$WORK/rt_$label.link.log" \
		|| { echo "LINK FAILED (rt $label):"; cat "$WORK/rt_$label.link.log"; exit 1; }
	"$OBJCOPY" -O binary "$elf" "$bin"
	wc -c <"$bin" | tr -d ' '
}

echo "=== code size: math32 vs compiler-rt division, delta vs no-op baseline ==="

m32_base=$(build_math32 base "")
m32_div=$(build_math32 div  "volatile float rf = a / b;")
rt_base=$(build_compilerrt base "" "")
rt_div=$(build_compilerrt div "rf = a / b;" "$RT_LIB/divsf3.o")

m32_delta=$((m32_div - m32_base))
rt_delta=$((rt_div - rt_base))

printf "math32:      baseline=%s  +div=%s  delta=%s bytes\n" "$m32_base" "$m32_div" "$m32_delta"
printf "compiler-rt: baseline=%s  +div=%s  delta=%s bytes\n" "$rt_base" "$rt_div" "$rt_delta"

if [ "$m32_delta" -lt "$rt_delta" ]; then
	echo "winner: math32 (smaller by $((rt_delta - m32_delta)) bytes)"
elif [ "$rt_delta" -lt "$m32_delta" ]; then
	echo "winner: compiler-rt (smaller by $((m32_delta - rt_delta)) bytes)"
else
	echo "tie"
fi

echo "PASS: bench_math32_vs_compilerrt_size (m32_delta=$m32_delta, rt_delta=$rt_delta)"
