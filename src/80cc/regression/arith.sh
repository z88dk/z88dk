#!/bin/bash
# 80cc regression: long mul/div/mod, int mod, OP_LNEG on long, and
# local array initializer lists. All compiled through the IR pipeline, linked
# with z80_clib + math libs, run under z88dk-ticks, and checked
# against expected HL at the harness exit point.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_arith}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.c "$WORK"/*.trace

ok=0
fail=0
failures=()

run_test() {
    local name="$1" expected="$2" src="$3"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"
    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: 80cc failed"); return
    fi
    if ! ( cd "$WORK" && reg_z80asm "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: z80asm failed"); return
    fi
    "$TICKS" -end 6 -trace "$bin" > "$trace" 2>&1
    local hl
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ -z "$hl" ]; then
        fail=$((fail+1)); failures+=("$name: no pc=000D trace line"); return
    fi
    hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name: expected hl=$expected, got hl=$hl")
    fi
}

# --- int mod ----------------------------------------------------------
run_test "imod_signed"   "0005" '
static int a, b;
int main(void) { a = 17; b = 6; return a % b; }'

run_test "imod_unsigned" "0004" '
static unsigned a, b;
int main(void) { a = 100; b = 32; return a % b; }'

# --- long mul / div / mod ---------------------------------------------
# 100000 * 7 = 700000 → 0x000AAE60. Low 16 = 0xAE60.
run_test "lmul"          "AE60" '
static long a, b;
int main(void) { a = 100000L; b = 7L; return (int)(a * b); }'

# 1000000 / 13 = 76923 = 0x12C7B. Low 16 = 0x2C7B.
run_test "ldiv_signed"   "2C7B" '
static long a, b;
int main(void) { a = 1000000L; b = 13L; return (int)(a / b); }'

run_test "ludiv"         "2C7B" '
static unsigned long a, b;
int main(void) { a = 1000000UL; b = 13UL; return (int)(a / b); }'

# 1000000 % 13 = 1 (1000000 = 76923 * 13 + 1).
run_test "lmod_signed"   "0001" '
static long a, b;
int main(void) { a = 1000000L; b = 13L; return (int)(a % b); }'

run_test "lumod"         "0001" '
static unsigned long a, b;
int main(void) { a = 1000000UL; b = 13UL; return (int)(a % b); }'

# --- OP_LNEG on long --------------------------------------------------
run_test "lneg_zero"    "0001" '
static long a;
int main(void) { a = 0L; return !a; }'

run_test "lneg_nonzero" "0000" '
static long a;
int main(void) { a = 0x12345678L; return !a; }'

# --- Local array init list -------------------------------------------
run_test "iarray_init"   "0014" '
int main(void) { int a[] = {10, 20, 30}; return a[1]; }'

run_test "carray_init"   "0042" '
int main(void) { char a[] = {0x10, 0x42, 0x33}; return a[1]; }'

run_test "larray_init"   "5678" '
int main(void) {
    long a[] = {0xDEAD1234L, 0xBEEF5678L};
    return (int) a[1];
}'

# Nested array initialiser flattens to scalar stores. a[1][2] = 6.
run_test "nested_init"   "0006" '
int main(void) {
    int a[2][3] = {{1,2,3},{4,5,6}};
    return a[1][2];
}'

# Struct global decay: `suite.tests[0]` (parser shape `(deref (+
# (gv=suite) N))`) used to read suite.num+N as a pointer, returning
# garbage. Now `gv=suite` decays to &suite. Regression test stores
# a pointer through a walker-compiled function (bails on the struct
# write LHS) and reads it back from IR-compiled main.
run_test "struct_addr_decay" "00C8" '
static struct { int num; int slot; } s;
void put(int v) { s.slot = v; }
int main(void) { s.num = 1; put(200); return s.slot; }'

# Struct local: address-of + member read through a function pointer
# write. Exercises new_local_vreg KIND_STRUCT, AST_LOCAL_VAR struct
# decay (LEA), and OP_DEREF aggregate (offset-0 member read).
run_test "struct_local" "0007" '
struct s { int a; int b; };
void fill(struct s *p, int v) { p->a = v; }
int main(void) { struct s p; fill(&p, 7); return p.a; }'

# Array offset-0 write via the folded `arr[0] = X` shape — exercises
# the OP_ASSIGN AST_LOCAL_VAR aggregate-LHS path.
run_test "array_offset0_write" "00FF" '
int main(void) { unsigned char a[8]; a[0] = 0xff; return a[0]; }'

# sprintf with __LIB__ + __vasmallc: must call `sprintf` (the SMALLC
# sccz80 implementation) not `_sprintf` (the SDCC/STDC variant).
# Without the __LIB__ annotation the IR emits `call _sprintf` with
# SMALLC (L→R) push order, swapping buf and fmt — buf[0] stays 0.
# `buf[0]` after sprintf(buf,"X") = 'X' = 0x58, sign-extended = 0x0058.
run_test "sprintf_small" "0058" '
extern int __LIB__ sprintf(char *s, const char *fmt, ...) __smallc;
int main(void) {
    char buf[32];
    sprintf(buf, "X");
    return buf[0];
}'

# Same but with a 200-byte local array that forces sp-mode addressing
# (frame > 128 bytes). Exercises sp-relative LEA + variadic call together.
run_test "sprintf_spmode" "0058" '
extern int __LIB__ sprintf(char *s, const char *fmt, ...) __smallc;
int main(void) {
    char data[200];
    sprintf(data, "X");
    return data[0];
}'

# BC-cache stale across calls with two PR_BC-eligible params.
# ir_alloc gives both params non-overlapping PR_BC slots. `a` is used
# first (gets the prologue BC load). During the `sink(b)` call setup,
# emit_bc_reload reloads BC with `b`. After the bc-save pop restores
# BC=a, a stale cur_bc_vreg=b would make the next `return b` emit
# `ld hl,bc` (yielding a's value, 3) instead of a fresh slot read (7).
run_test "bc_cache_stale" "0007" '
static int sink(int x) { return x; }
static int two_param(int a, int b) {
    int x = a + a;
    int y = sink(b);
    return b;
}
int main(void) { return two_param(3, 7); }'

echo "arith suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
