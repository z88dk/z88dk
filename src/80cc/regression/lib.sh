# Shared helpers for the 80cc regression scripts.
#
# Source this from each suite via `. "$(dirname "$0")/lib.sh"`.
# Discovers the compiler under test, the z88dk install paths and
# the assembler/emulator, with env-var overrides for each.

# Resolve this script's directory (works regardless of cwd).
REG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Compiler under test. Override via `COMPILER=/path/to/binary`.
# `SCCZ80` is accepted as a backward-compat alias.
# Default discovery, in order:
#   1. $COMPILER if set
#   2. $SCCZ80 if set (legacy)
#   3. fresh source build at $REG_DIR/../z88dk-80cc (this is the
#      filename the Makefile actually produces — preferred)
#   4. legacy `80cc` name in $REG_DIR/.. (older builds)
#   5. installed z88dk-80cc on PATH
COMPILER="${COMPILER:-${SCCZ80:-}}"
if [ -z "$COMPILER" ]; then
    if [ -x "$REG_DIR/../z88dk-80cc" ]; then
        COMPILER="$REG_DIR/../z88dk-80cc"
    elif [ -x "$REG_DIR/../80cc" ]; then
        COMPILER="$REG_DIR/../80cc"
    else
        COMPILER="z88dk-80cc"  # resolved against PATH later
    fi
fi
# Backward-compat alias for any callers still reading $SCCZ80.
SCCZ80="$COMPILER"

# Legacy compiler — used for byte-for-byte parity comparisons in
# the far / const-fold suites. Optional: suites that need it will
# skip with a clear message if it's not on PATH.
LEGACY_SCCZ80="${LEGACY_SCCZ80:-z88dk-sccz80}"

# z88dk install paths. We need:
#   $Z88DK_LIB         — base lib dir (.hdr files live here)
#   $Z88DK_LIB/clibs   — runtime libraries (z80_crt0, z80_clib, mathN)
# Resolution order:
#   1. $Z88DK_LIB env var (full override)
#   2. $Z88DK_HOME/lib if $Z88DK_HOME is set
#   3. derive from `z88dk-z80asm`'s install location (../lib)
#   4. fall back to /usr/local/share/z88dk/lib
if [ -z "${Z88DK_LIB:-}" ]; then
    if [ -n "${Z88DK_HOME:-}" ]; then
        Z88DK_LIB="$Z88DK_HOME/lib"
    elif command -v z88dk-z80asm >/dev/null 2>&1; then
        _asm_bin=$(command -v z88dk-z80asm)
        Z88DK_LIB="$(cd "$(dirname "$_asm_bin")/../lib" 2>/dev/null && pwd)"
    fi
    Z88DK_LIB="${Z88DK_LIB:-/usr/local/share/z88dk/lib}"
fi

# Tools.
Z80ASM="${Z80ASM:-z88dk-z80asm}"
TICKS="${TICKS:-z88dk-ticks}"
UCPP="${UCPP:-z88dk-ucpp}"

# Per-suite default harness asm (sits in the regression dir).
HARNESS="${HARNESS:-$REG_DIR/harness.asm}"

# Standard z80asm invocation: builds a flat binary with crt0 + clib
# + math libs, links the suite harness and the compiled .asm.
# Args: $1 = output binary path, $2... = input .asm files.
#
# `-O<dir>` directs z80asm to write intermediate .o files into the
# target directory rather than alongside each input — without it,
# the harness.o would land in the regression/ checkout.
reg_z80asm() {
    local out=$1; shift
    local outdir=$(dirname "$out")
    "$Z80ASM" -b "-o$out" "-O$outdir" \
        "-I$Z88DK_LIB" "-L$Z88DK_LIB/clibs" \
        -lz80_crt0 -lz80_clib -lmath16 -lmath48 \
        "$@"
}

# Same but for GBZ80 targets. The harness is target-neutral (only
# uses `jp` + a pad to 0x06 + an `ld a,0` placeholder); -end 6
# stops ticks before any invalid-opcode bytes execute, so the same
# harness.asm works under both CPUs.
reg_gbz80asm() {
    local out=$1; shift
    local outdir=$(dirname "$out")
    "$Z80ASM" -mgbz80 -b "-o$out" "-O$outdir" \
        "-I$Z88DK_LIB" "-L$Z88DK_LIB/clibs" \
        -lgbz80_crt0 -ltestgbz80_clib \
        "$@"
}

# Generic CPU-aware assembly helper. `$cpu` is one of 8080 / 8085 /
# ez80_z80 / kc160 / r2ka / r4k / gbz80 — matches the suffix of the
# corresponding `<cpu>_crt0.lib` / `test<cpu>_clib.lib`. Rabbits
# use `testrcm_clib` / `testrcm4k_clib` instead of test<cpu>_clib.
reg_cpu_asm() {
    local cpu=$1; local out=$2; shift 2
    local outdir=$(dirname "$out")
    local clib
    case "$cpu" in
        z80)   clib="z80_clib"       ;;
        z80n)  clib="z80_clib"       ;;  # z80n is z80-superset; no dedicated test clib
        z180)  clib="z80_clib"       ;;  # z180 too
        r2ka)  clib="testrcm_clib"   ;;
        r4k)   clib="testrcm4k_clib" ;;
        *)     clib="test${cpu}_clib" ;;
    esac
    # Plain z80 / z80n / z180 use z80_clib which needs math libs.
    local extra=
    case "$cpu" in
        z80|z80n|z180) extra="-lmath16 -lmath48" ;;
    esac
    "$Z80ASM" "-m$cpu" -b "-o$out" "-O$outdir" \
        "-I$Z88DK_LIB" "-L$Z88DK_LIB/clibs" \
        "-l${cpu}_crt0" "-l$clib" $extra \
        "$@"
}

# Sanity: warn early if anything's missing.
reg_check_env() {
    local missing=
    # If $COMPILER is a bare name (no slash), resolve it through PATH.
    if [ "${COMPILER#*/}" = "$COMPILER" ]; then
        if command -v "$COMPILER" >/dev/null 2>&1; then
            COMPILER="$(command -v "$COMPILER")"
            SCCZ80="$COMPILER"
        fi
    fi
    [ -x "$COMPILER" ] || missing="$missing\n  COMPILER=$COMPILER (not executable)"
    command -v "$Z80ASM" >/dev/null 2>&1 || missing="$missing\n  Z80ASM=$Z80ASM (not on PATH)"
    [ -d "$Z88DK_LIB" ] || missing="$missing\n  Z88DK_LIB=$Z88DK_LIB (not a directory)"
    [ -f "$HARNESS" ] || missing="$missing\n  HARNESS=$HARNESS (not found)"
    if [ -n "$missing" ]; then
        printf "regression: environment not ready:%b\n" "$missing" >&2
        printf "  override with env vars: COMPILER, Z80ASM, Z88DK_LIB, TICKS, UCPP\n" >&2
        return 1
    fi
    return 0
}
