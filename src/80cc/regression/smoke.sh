#!/bin/bash
# sccz80 regression: end-to-end smoke suite.
#
# Each test compiles a short C program with sccz80, assembles it
# alongside the test harness, runs under z88dk-ticks with -end 6
# (which stops the emulator at the harness's _exit label), and
# asserts that HL holds the expected value at that point. HL is
# the C return-from-main value, so each test's source encodes the
# expected outcome as `return EXPR`.
#
# Usage: bash smoke.sh
# override paths via env: COMPILER, Z80ASM, Z88DK_LIB, TICKS

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_smoke}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.trace

ok=0
fail=0
failures=()

# Each test: a function name, the expected HL, and the C source.
run_test() {
    local name="$1"
    local expected="$2"
    local src="$3"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    # sccz80 popens z88dk-ucpp itself (Phase L1 of the tokeniser
    # work), so the `.c` text goes through real preprocessing and
    # the `# 1` / `INCLUDE` / MODULE bookkeeping happens
    # automatically — no need to prefix the source manually.
    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: sccz80 failed"); return
    fi
    if ! ( cd "$WORK" && reg_z80asm "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: z80asm failed"); return
    fi
    "$TICKS" -end 6 -trace "$bin" > "$trace" 2>&1
    # Last "pc=000D" line shows the state right before jp _exit; HL is the return value.
    local hl
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ -z "$hl" ]; then
        fail=$((fail+1)); failures+=("$name: no pc=000D trace line"); return
    fi
    # Normalize hex to lowercase for comparison.
    hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name: expected hl=$expected, got hl=$hl")
    fi
}

run_test "ret0"      "0000" 'int main(void) { return 0; }'
run_test "ret42"     "002A" 'int main(void) { return 42; }'
run_test "retneg"    "FFFF" 'int main(void) { return -1; }'
run_test "ret256"    "0100" 'int main(void) { return 256; }'
run_test "one_local" "0005" 'int main(void) { int x = 5; return x; }'
run_test "two_add"   "000F" 'int main(void) { int x = 5; int y = 10; return x + y; }'
run_test "sub"       "0007" 'int main(void) { int x = 10; int y = 3; return x - y; }'
run_test "reassign"  "0064" 'int main(void) { int x = 5; x = 100; return x; }'

# Tests that exercise the frame plan (const-prop can't fold globals).
run_test "global_to_local" "0007" 'static int g = 7;
int main(void) { int x; x = g; return x; }'

run_test "global_two_locals" "0011" 'static int g = 7;
int main(void) { int x; int y; x = g; y = 10; return x + y; }'

# Phase C — binops, unops, comparisons, shifts (use globals to defeat const-prop).
run_test "mult"       "0042" 'static int g = 11;
int main(void) { return g * 6; }'
run_test "div"        "0007" 'static int g = 21;
int main(void) { return g / 3; }'
run_test "mod"        "0001" 'static int g = 7;
int main(void) { return g % 3; }'
run_test "and_const"  "0007" 'static int g = 0xFF;
int main(void) { return g & 7; }'
run_test "or_const"   "00FF" 'static int g = 0xF0;
int main(void) { return g | 0x0F; }'
run_test "xor_const"  "00AA" 'static int g = 0xFF;
int main(void) { return g ^ 0x55; }'
run_test "shl"        "0028" 'static int g = 5;
int main(void) { return g << 3; }'
run_test "shr"        "0005" 'static int g = 40;
int main(void) { return g >> 3; }'
run_test "neg"        "FFF9" 'static int g = 7;
int main(void) { return -g; }'
run_test "comp"       "FFF8" 'static int g = 7;
int main(void) { return ~g; }'
run_test "lneg_zero"  "0001" 'static int g = 0;
int main(void) { return !g; }'
run_test "lneg_nz"    "0000" 'static int g = 5;
int main(void) { return !g; }'
run_test "cmp_eq"     "0001" 'static int g = 7;
int main(void) { return g == 7; }'
run_test "cmp_ne"     "0001" 'static int g = 7;
int main(void) { return g != 5; }'
run_test "cmp_lt"     "0001" 'static int g = 5;
int main(void) { return g < 7; }'
run_test "cmp_ge"     "0001" 'static int g = 7;
int main(void) { return g >= 7; }'
run_test "two_globals_add" "000B" 'static int a = 4; static int b = 7;
int main(void) { return a + b; }'
run_test "two_globals_mul" "0014" 'static int a = 4; static int b = 5;
int main(void) { return a * b; }'

# Phase D — control flow.
run_test "if_taken"      "002A" 'static int g = 1;
int main(void) { if (g) return 42; return 0; }'
run_test "if_not_taken"  "0000" 'static int g = 0;
int main(void) { if (g) return 42; return 0; }'
run_test "if_else_t"     "000A" 'static int g = 1;
int main(void) { int r; if (g) r = 10; else r = 20; return r; }'
run_test "if_else_f"     "0014" 'static int g = 0;
int main(void) { int r; if (g) r = 10; else r = 20; return r; }'
run_test "ternary_t"     "000A" 'static int g = 1;
int main(void) { return g ? 10 : 20; }'
run_test "ternary_f"     "0014" 'static int g = 0;
int main(void) { return g ? 10 : 20; }'

run_test "oror_lhs_true"   "0001" 'static int a = 5; static int b = 0;
int main(void) { return a || b; }'
run_test "oror_rhs_true"   "0001" 'static int a = 0; static int b = 7;
int main(void) { return a || b; }'
run_test "oror_both_false" "0000" 'static int a = 0; static int b = 0;
int main(void) { return a || b; }'

run_test "andand_both_t"   "0001" 'static int a = 5; static int b = 7;
int main(void) { return a && b; }'
run_test "andand_lhs_f"    "0000" 'static int a = 0; static int b = 7;
int main(void) { return a && b; }'
run_test "andand_rhs_f"    "0000" 'static int a = 5; static int b = 0;
int main(void) { return a && b; }'

# User-level goto/label (Q18 in AST + Phase D).
run_test "goto_forward"  "0007" 'static int g = 7;
int main(void) {
    if (g == 0) goto err;
    return g;
err:
    return -1;
}'

# Conditional comparison + return.
run_test "cmp_and_branch" "0001" 'static int g = 5;
int main(void) {
    if (g < 10) return 1;
    return 0;
}'

# Phase E — function calls.
run_test "call_no_args"     "002A" 'int helper(void) { return 42; }
int main(void) { return helper(); }'

run_test "call_one_arg"     "001E" 'int helper(int n) { return n * 2; }
int main(void) { return helper(15); }'

run_test "call_two_args"    "0019" 'int helper(int a, int b) { return a * b; }
int main(void) { return helper(5, 5); }'

run_test "call_three_args"  "001E" 'int helper(int a, int b, int c) { return a + b + c; }
int main(void) { return helper(5, 10, 15); }'

run_test "call_chain"       "0014" 'int add(int a, int b) { return a + b; }
int double_it(int n) { return n + n; }
int main(void) { return double_it(add(3, 7)); }'

run_test "call_uses_global" "002A" 'static int g = 6;
int helper(int n) { return g * n; }
int main(void) { return helper(7); }'

# Recursion (factorial).
run_test "fact_3"           "0006" 'int fact(int n) {
    if (n < 2) return 1;
    return n * fact(n - 1);
}
int main(void) { return fact(3); }'

run_test "fact_5"           "0078" 'int fact(int n) {
    if (n < 2) return 1;
    return n * fact(n - 1);
}
int main(void) { return fact(5); }'

# Phase F — initializers.
run_test "global_init"      "002A" 'int g = 42;
int main(void) { return g; }'

run_test "local_arr_idx0"   "000A" 'int main(void) {
    int arr[3] = {10, 20, 30};
    return arr[0];
}'
run_test "local_arr_idx1"   "0014" 'int main(void) {
    int arr[3] = {10, 20, 30};
    return arr[1];
}'
run_test "local_arr_idx2"   "001E" 'int main(void) {
    int arr[3] = {10, 20, 30};
    return arr[2];
}'
run_test "local_arr_sum"    "003C" 'int main(void) {
    int arr[3] = {10, 20, 30};
    return arr[0] + arr[1] + arr[2];
}'

run_test "local_str_first"  "0068" 'int main(void) {
    char str[] = "hello";
    return str[0];
}'
run_test "local_str_third"  "006C" 'int main(void) {
    char str[] = "hello";
    return str[2];
}'

run_test "addr_of_local"    "0064" 'int main(void) {
    int x = 100;
    int *p = &x;
    return *p;
}'

# Phase D' — switch.
run_test "switch_int_case1"  "000A" 'static int gx = 1;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1: r = 10; break;
        case 2: r = 20; break;
        case 3: r = 30; break;
    }
    return r;
}'

run_test "switch_int_case2"  "0014" 'static int gx = 2;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1: r = 10; break;
        case 2: r = 20; break;
        case 3: r = 30; break;
    }
    return r;
}'

run_test "switch_int_case3"  "001E" 'static int gx = 3;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1: r = 10; break;
        case 2: r = 20; break;
        case 3: r = 30; break;
    }
    return r;
}'

run_test "switch_default_taken" "0063" 'static int gx = 99;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1: r = 10; break;
        case 2: r = 20; break;
        default: r = 99; break;
    }
    return r;
}'

run_test "switch_default_skip"  "000A" 'static int gx = 1;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1: r = 10; break;
        case 2: r = 20; break;
        default: r = 99; break;
    }
    return r;
}'

run_test "switch_no_match_no_default" "0000" 'static int gx = 99;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1: r = 10; break;
        case 2: r = 20; break;
    }
    return r;
}'

run_test "switch_fallthrough"   "001E" 'static int gx = 1;
int main(void) {
    int r = 0;
    switch (gx) {
        case 1:
        case 2: r = 30; break;
        case 3: r = 99; break;
    }
    return r;
}'

run_test "switch_char_default" "0042" 'int f(char c) {
    switch (c) {
        case 1: return 10;
        case 2: return 20;
        case 3: return 30;
        default: return 66;
    }
}
int main(void) { return f(99); }'

run_test "switch_char_match"   "0014" 'int f(char c) {
    switch (c) {
        case 1: return 10;
        case 2: return 20;
        case 3: return 30;
        default: return 66;
    }
}
int main(void) { return f(2); }'

# Struct value handling — member read/write, mixed widths.
run_test "struct_first_member"  "000A" 'struct point { int x; int y; };
int main(void) {
    struct point p;
    p.x = 10;
    p.y = 20;
    return p.x;
}'

run_test "struct_second_member" "0014" 'struct point { int x; int y; };
int main(void) {
    struct point p;
    p.x = 10;
    p.y = 20;
    return p.y;
}'

run_test "struct_int_sum"       "001E" 'struct point { int x; int y; };
int main(void) {
    struct point p;
    p.x = 10;
    p.y = 20;
    return p.x + p.y;
}'

run_test "struct_mixed_sum"     "0131" 'struct rec { int x; char c; int y; };
int main(void) {
    struct rec r;
    r.x = 100;
    r.c = 5;
    r.y = 200;
    return r.x + r.c + r.y;
}'

run_test "struct_char_member"   "0005" 'struct rec { int x; char c; int y; };
int main(void) {
    struct rec r;
    r.c = 5;
    return r.c;
}'

run_test "struct_char_in_int"   "00FF" 'struct rec { int x; char c; int y; };
int main(void) {
    struct rec r;
    r.c = 0xFF;
    return r.c & 0xFF;
}'

run_test "struct_via_ptr"       "002A" 'struct point { int x; int y; };
int main(void) {
    struct point p;
    struct point *q = &p;
    q->x = 42;
    q->y = 7;
    return q->x;
}'

run_test "struct_via_ptr_sum"   "0031" 'struct point { int x; int y; };
int main(void) {
    struct point p;
    struct point *q = &p;
    q->x = 42;
    q->y = 7;
    return q->x + q->y;
}'

# Function pointer calls.
run_test "fnptr_simple"      "000E" 'int twice(int x) { return x + x; }
int main(void) {
    int (*fp)(int);
    fp = twice;
    return fp(7);
}'

run_test "fnptr_two_args"    "0019" 'int add(int a, int b) { return a + b; }
int main(void) {
    int (*fp)(int, int);
    fp = add;
    return fp(20, 5);
}'

run_test "fnptr_swap"        "0028" 'int add(int a, int b) { return a + b; }
int sub(int a, int b) { return a - b; }
int main(void) {
    int (*fp)(int, int);
    int r;
    fp = add;
    r = fp(20, 5);
    fp = sub;
    r = r + fp(20, 5);
    return r;
}'

run_test "fnptr_as_arg"      "0051" 'int sq(int x) { return x * x; }
int apply(int (*f)(int), int x) { return f(x); }
int main(void) {
    return apply(sq, 9);
}'

run_test "fnptr_array"       "0007" 'int a(void) { return 1; }
int b(void) { return 2; }
int c(void) { return 4; }
int main(void) {
    int (*fns[3])(void);
    fns[0] = a;
    fns[1] = b;
    fns[2] = c;
    return fns[0]() + fns[1]() + fns[2]();
}'

# Long (32-bit) value handling.
run_test "long_decl_truncate" "86A0" 'int main(void) {
    long x = 100000;
    return (int)x;
}'

run_test "long_global_add"    "49F0" 'static long ga = 100000;
static long gb = 50000;
int main(void) {
    long r = ga + gb;
    return (int)r;
}'

run_test "long_global_sub"    "C350" 'static long ga = 70000;
static long gb = 20000;
int main(void) {
    return (int)(ga - gb);
}'

run_test "long_compare_gt"    "0001" 'static long ga = 100000;
static long gb = 99999;
int main(void) {
    if (ga > gb) return 1;
    return 0;
}'

run_test "long_compare_eq"    "0000" 'static long ga = 100000;
static long gb = 99999;
int main(void) {
    if (ga == gb) return 1;
    return 0;
}'

run_test "int_to_long_promote" "86A0" 'static int gi = 1000;
int main(void) {
    long x = (long)gi * 100;
    return (int)x;
}'

run_test "long_func_call"     "ADB0" 'long add(long a, long b) { return a + b; }
int main(void) {
    long r = add(60000L, 50000L);
    return (int)r;
}'

run_test "long_loop_acc"      "03E8" 'int main(void) {
    long acc = 0;
    int i = 0;
    while (i < 10) {
        acc = acc + 100000;
        i = i + 1;
    }
    return (int)(acc / 1000);
}'

# Mixed-width ternary: false branch must promote int→long
# rather than leaking DE from earlier code.
run_test "ternary_long_true"  "0064" 'static int gx = 1;
int main(void) {
    long r = gx ? 100000L : 0;
    return (int)(r / 1000);
}'

run_test "ternary_long_false" "0000" 'static long ga;
static int gx;
int main(void) {
    long pollute;
    long r;
    ga = 0xDEAD0001L;
    gx = 0;
    pollute = ga;
    r = gx ? 100000L : 0;
    return (int)(r >> 16);
}'

# Long shifts (asl_const / asr_const handle KIND_LONG; the
# const-RHS fastpath now allows them. Variable count goes
# through the general path with HL = count, TOS = long value.)
run_test "long_shl_const"     "000E" 'static long ga = 7;
int main(void) {
    long r = ga << 17;
    return (int)(r >> 16);
}'

run_test "long_shr_signed"    "FFFF" 'static long ga = -1L;
int main(void) {
    long r = ga >> 4;
    return (int)r;
}'

run_test "long_shr_unsigned"  "FFFF" 'static unsigned long ga = 0xFFFFFFFFUL;
int main(void) {
    unsigned long r = ga >> 4;
    return (int)(r >> 12);
}'

run_test "long_shl_var"       "0100" 'static long ga = 1;
static int gn = 24;
int main(void) {
    long r = ga << gn;
    return (int)(r >> 16);
}'

run_test "long_shr_var_unsig" "3456" 'static unsigned long ga = 0x12345678UL;
static int gn = 8;
int main(void) {
    unsigned long r = ga >> gn;
    return (int)(r & 0xFFFF);
}'

# Pre/post-increment/decrement.
run_test "pp_post_inc_int"   "000B" 'int main(void) {
    int x = 5;
    int y = x++;
    return x + y;
}'

run_test "pp_pre_inc_int"    "000C" 'int main(void) {
    int x = 5;
    int y = ++x;
    return x + y;
}'

run_test "pp_post_dec_pre_dec" "038C" 'int main(void) {
    int x = 10;
    int y = x--;
    int z = --x;
    return x * 100 + y * 10 + z;
}'

run_test "pp_for_loop_sum"   "002D" 'int main(void) {
    int sum = 0;
    int i;
    for (i = 0; i < 10; i++) {
        sum = sum + i;
    }
    return sum;
}'

run_test "pp_global_post_inc" "0055" 'static int g = 42;
int main(void) {
    int y = g++;
    return g + y;
}'

run_test "pp_long_post_inc"  "0001" 'int main(void) {
    long x = 99999;
    long y = x++;
    return (int)(x - y);
}'

run_test "pp_char_post_inc"  "1A09" 'int main(void) {
    char c = 65;
    int x = c++;
    return c * 100 + x;
}'

run_test "pp_ptr_post_inc"   "001E" 'int arr[5] = {10, 20, 30, 40, 50};
int main(void) {
    int *p = &arr[0];
    int a = *p++;
    int b = *p;
    return a + b;
}'

# Compound assignments (+=, -=, *=, /=, %=, |=, &=, ^=, <<=, >>=).
run_test "ca_add_local"   "0008" 'static int g = 5;
int main(void) {
    int x = g;
    x += 3;
    return x;
}'

run_test "ca_all_int"     "0070" 'static int g = 100;
int main(void) {
    int a;
    int b;
    a = 50;
    b = 6;
    a -= 10;
    a *= 2;
    a /= 4;
    a %= 7;
    a |= 1;
    a &= 5;
    a ^= 3;
    a <<= 2;
    a >>= 1;
    g += a;
    return g;
}'

run_test "ca_long"        "00C8" 'int main(void) {
    long x = 50000L;
    x += 50000L;
    x *= 2L;
    return (int)(x / 1000);
}'

run_test "ca_global"      "002A" 'static int g = 30;
int main(void) {
    g -= 5;
    g += 17;
    return g;
}'

run_test "ca_value_used"  "003C" 'int main(void) {
    int x = 50;
    int y;
    y = (x += 10) * 2;
    return y - x;
}'

# Long || / && — must test all 32 bits, not just the low half.
run_test "lor_high_only"  "0001" 'static long ga = 65536L;
static long gb = 0L;
int main(void) {
    if (ga || gb) return 1;
    return 0;
}'

run_test "land_both_high" "0001" 'static long ga = 65536L;
static long gb = 65536L;
int main(void) {
    if (ga && gb) return 1;
    return 0;
}'

run_test "land_one_zero"  "0000" 'static long ga = 65536L;
static long gb = 0L;
int main(void) {
    if (ga && gb) return 1;
    return 0;
}'

# Bitfield read-modify-write. DSE no longer drops the earlier
# writes; walker emits per-byte mask/or for in-byte fields and
# the two-byte path for fields that straddle a byte boundary.
run_test "bf_three_in_word" "001F" 'struct flags {
    unsigned a : 3;
    unsigned b : 5;
    unsigned c : 4;
};
int main(void) {
    struct flags f;
    f.a = 5;
    f.b = 17;
    f.c = 9;
    return f.a + f.b + f.c;
}'

run_test "bf_straddle"      "0052" 'struct big {
    unsigned a : 5;
    unsigned b : 6;
    unsigned c : 5;
};
int main(void) {
    struct big g;
    g.a = 1;
    g.b = 50;
    g.c = 31;
    return g.a + g.b + g.c;
}'

run_test "bf_signed"        "0004" 'struct s {
    signed int a : 4;
    unsigned int b : 4;
};
int main(void) {
    struct s x;
    x.a = -3;
    x.b = 7;
    return x.a + x.b;
}'

run_test "bf_readback"      "0064" 'struct s {
    unsigned a : 3;
    unsigned b : 5;
};
int main(void) {
    struct s x;
    x.a = 7;
    x.b = 25;
    if (x.a == 7) {
        if (x.b == 25) return 100;
    }
    return 0;
}'

# Struct value-passing.
run_test "struct_init_list" "001E" 'struct point { int x; int y; };
int main(void) {
    struct point p = {10, 20};
    return p.x + p.y;
}'

run_test "struct_init_mixed" "42A9" 'struct rec { int x; char c; long n; };
int main(void) {
    struct rec r = {100, 5, 1000000L};
    return r.x + r.c + (int)r.n;
}'

run_test "struct_copy"      "001E" 'struct point { int x; int y; };
int main(void) {
    struct point a;
    struct point b;
    a.x = 10;
    a.y = 20;
    b = a;
    return b.x + b.y;
}'

run_test "struct_copy_mixed" "42A9" 'struct rec { int x; char c; long n; };
int main(void) {
    struct rec a = {100, 5, 1000000L};
    struct rec b;
    b = a;
    return b.x + b.c + (int)b.n;
}'

run_test "struct_byval_arg" "001E" 'struct point { int x; int y; };
int sum(struct point p) { return p.x + p.y; }
int main(void) {
    struct point a;
    a.x = 10;
    a.y = 20;
    return sum(a);
}'

# Pre/post-step on non-bare lvalues (member access, *p).
run_test "pp_field_off0"   "000D" 'struct s { int x; int y; };
int main(void) {
    struct s a;
    a.x = 5;
    a.y = 7;
    a.x++;
    return a.x + a.y;
}'

run_test "pp_field_off2"   "0010" 'struct s { int x; int y; };
int main(void) {
    struct s a;
    a.x = 5;
    a.y = 10;
    a.y++;
    return a.x + a.y;
}'

run_test "pp_field_value"  "03F3" 'struct s { int x; int y; };
int main(void) {
    struct s a;
    int r;
    a.x = 5;
    a.y = 10;
    r = a.y++;
    return r * 100 + a.y;
}'

run_test "pp_deref_ptr"    "0006" 'int g = 5;
int main(void) {
    int *p = &g;
    (*p)++;
    return g;
}'

run_test "pp_deref_long"   "86A0" 'long g = 99999L;
int main(void) {
    long *p = &g;
    (*p)++;
    return (int)g;
}'

run_test "pp_deref_char"   "0042" 'char g = 65;
int main(void) {
    char *p = &g;
    (*p)++;
    return g;
}'

# Static locals with initializers — initials() emission must reach
# the data section even with c_quiet_codegen suppressing body emit.
run_test "static_local"    "0005" 'int main(void) {
    static int a = 5;
    return a;
}'

run_test "static_local_arr" "003C" 'int sum(void) {
    static int A[3] = {10, 20, 30};
    return A[0] + A[1] + A[2];
}
int main(void) { return sum(); }'

run_test "static_local_persist" "0003" 'int next(void) {
    static int n = 0;
    n = n + 1;
    return n;
}
int main(void) {
    next();
    next();
    return next();
}'

# Width-aware truthiness regression — `if (long_var)` must test all
# four bytes, not just HL. Without the fix, a long whose low 16 bits
# are zero but whose high bits are non-zero (e.g. 0x10000) would be
# misclassified as false. testjump now dispatches on val_type.
run_test "if_long_low_zero"  "BEEF" 'static long g = 0x10000L;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

run_test "if_long_zero"      "DEAD" 'static long g = 0L;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

run_test "if_long_neg"       "BEEF" 'static long g = -1L;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

run_test "if_long_high_bit"  "BEEF" 'static unsigned long g = 0x80000000UL;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

# Long long truthiness — the i64 value lives in __i64_acc (memory)
# after l_i64_load, not in registers. testjump calls `l_i64_eq0`
# which tests all 8 bytes at __i64_acc.
run_test "if_llong_low_zero" "BEEF" 'static long long g = 0x100000000LL;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

run_test "if_llong_zero"     "DEAD" 'static long long g = 0LL;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

run_test "if_llong_high_only" "BEEF" 'static unsigned long long g = 0x8000000000000000ULL;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

run_test "if_llong_one"      "BEEF" 'static long long g = 1LL;
int main(void) { if (g) return 0xBEEF; return 0xDEAD; }'

# Same width-aware truthiness for short-circuit && / || — the walker
# uses cg2_truthiness_test which now handles KIND_LONG/CPTR/LONGLONG.
# Without these cases, `long_g || other` with g whose low 16 = 0
# but high non-zero would short-circuit incorrectly.
run_test "or_long_high_only"  "BEEF" 'static long g = 0x10000L;
static long h = 0L;
int main(void) { if (g || h) return 0xBEEF; return 0xDEAD; }'

run_test "or_long_both_zero"  "DEAD" 'static long g = 0L;
static long h = 0L;
int main(void) { if (g || h) return 0xBEEF; return 0xDEAD; }'

run_test "and_long_one_zero"  "DEAD" 'static long g = 0x10000L;
static long h = 0L;
int main(void) { if (g && h) return 0xBEEF; return 0xDEAD; }'

run_test "and_long_both_nz"   "BEEF" 'static long g = 0x10000L;
static long h = 0x20000L;
int main(void) { if (g && h) return 0xBEEF; return 0xDEAD; }'

run_test "or_llong_zero"      "DEAD" 'static long long g = 0LL;
static long long h = 0LL;
int main(void) { if (g || h) return 0xBEEF; return 0xDEAD; }'

run_test "or_llong_high_only" "BEEF" 'static long long g = 0x100000000LL;
static long long h = 0LL;
int main(void) { if (g || h) return 0xBEEF; return 0xDEAD; }'

run_test "and_llong_one_zero" "DEAD" 'static long long g = 0x100000000LL;
static long long h = 0LL;
int main(void) { if (g && h) return 0xBEEF; return 0xDEAD; }'

# Range-elision regression — ast_opt.c folds comparisons where one
# operand is a literal outside the typed operand's range. The dead
# branch then gets dropped by ast_dead_code. Without the fold the
# walker would emit a runtime comparison that always fails.
run_test "range_uchar_eq256"   "0000" 'static unsigned char c;
int main(void) { c = 100; if (c == 256) return 0xBEEF; return 0; }'

run_test "range_uchar_gt1000"  "0000" 'static unsigned char c;
int main(void) { c = 200; if (c > 1000) return 0xBEEF; return 0; }'

run_test "range_int_ge100000"  "0000" 'static int x;
int main(void) { x = 12345; if (x >= 100000) return 0xBEEF; return 0; }'

run_test "range_int_ltminus100000" "0001" 'static int x;
int main(void) { x = -1; if (x < -100000) return 0xBEEF; return 1; }'

# __func__ runtime — Tier 4 surfaced two bugs: (1) the shadowing
# `int32_t litlab` in primary.c referenced a bogus queue label
# (linker error); (2) walker treated `AST_LITERAL char*` as a
# numeric and emitted `vconst(offs)` on top of the parser-side
# `immedlit`, leaving HL = offset (runtime read from address 0).
# Both fixed: (1) renamed local to `offs`; (2) added AST_STR_LIT
# node type so the walker dispatches to `immedlit` for queue refs.
run_test "func_name_first_char" "006D" 'int main(void) { return __func__[0]; }'

# Same in a nested function — different queue offset, same shared
# global litlab. `foo` first char is 'f' = 0x66.
run_test "func_name_in_nested" "0066" 'int foo(void) { return __func__[0]; }
int main(void) { return foo(); }'

# String literal indexing — exercises the const.c::tstr → AST_STR_LIT
# path. Each char of "abcd" indexed; 0x63 = 'c'.
run_test "string_lit_index"  "0063" 'int main(void) { return "abcd"[2]; }'

# Div-by-zero — ast_opt::ast_fold_constants now fires the
# division-by-zero warning AND folds to literal 0. Catches both
# direct constants and const-prop-revealed RHS (after Q-series
# const-prop changes `x = 0; ... z/x;` into `z/0`).
run_test "div_by_zero_const"  "0000" 'int main(void) { return 5 / 0; }'
run_test "mod_by_zero_const"  "0000" 'int main(void) { return 5 % 0; }'

# Shift over object width — same pattern. Width comes from LHS
# type; over-shift folds to 0.
run_test "shift_overflow_int" "0000" 'int main(void) { return 1 << 20; }'
run_test "shr_overflow_int"   "0000" 'int main(void) { return 0xFFFF >> 20; }'

# Goto crossing locals — walker allocates the whole frame at function
# entry, so goto/label needs no SP adjustment regardless of how many
# locals (or CSE temps) live in scope. Pre-Tier-5 the parser tracked
# Zsp through GOTO_TAB.sp and conditionally emitted trampolines for
# stack mismatches; that machinery is gone now.
run_test "goto_with_locals" "0008" 'int main(void) {
    int a = 1; int b = 2; int c = 3;
    a = a + b + c;
    goto end;
    a = 99;
end:
    return a + b;
}'

run_test "goto_skipping_init" "000A" 'int main(void) {
    int x = 0;
    goto end;
    x = 99;
end:
    x = x + 10;
    return x;
}'

run_test "goto_back_in_loop" "000A" 'int main(void) {
    int i = 0;
top:
    i = i + 1;
    if (i < 10) goto top;
    return i;
}'

# Pointer subtraction — `p - q` returns the element difference, not
# the byte difference. Walker must emit a divide / shift after l_sub
# based on the LHS pointer's pointee size. Regression for the bug
# uncovered when comparing against z88dk-sccz80 (legacy emitted srl/rr
# scale; walker was emitting raw byte-diff).
run_test "ptrsub_int"  "0005" 'int arr[10];
int main(void) { int *p = &arr[7]; int *q = &arr[2]; return p - q; }'
run_test "ptrsub_long" "0005" 'long arr[10];
int main(void) { long *p = &arr[7]; long *q = &arr[2]; return p - q; }'
run_test "ptrsub_char" "0005" 'char arr[10];
int main(void) { char *p = &arr[7]; char *q = &arr[2]; return p - q; }'
run_test "ptrsub_struct" "0005" 'struct S { int a; int b; int c; } arr[10];
int main(void) { struct S *p = &arr[7]; struct S *q = &arr[2]; return p - q; }'

# Runtime array / pointer indexing — `arr[i]` and `*(p+i)` must scale
# `i` by element size. Pre-fix the walker emitted *(arr+i) without the
# *sizeof(elem) factor, returning the wrong array element. Function-arg
# `i` is opaque to const-prop so this exercises the runtime path.
run_test "arridx_runtime_int" "0064" 'int arr[10];
int get(int i) { return arr[i]; }
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return get(2);
}'

run_test "ptr_plus_const" "0064" 'int arr[10];
int get(int *p) { return *(p + 2); }
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return get(arr);
}'

run_test "ptr_plus_runtime" "03E8" 'int arr[10];
int get(int *p, int i) { return *(p + i); }
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return get(arr, 3);
}'

# Long-array runtime index — scale by 4.
run_test "arridx_runtime_long" "0064" 'long arr[10];
int get(int i) { return (int)arr[i]; }
int main(void) {
    arr[0]=1L; arr[1]=10L; arr[2]=100L; arr[3]=1000L;
    return get(2);
}'

# Compound assignment with pointer — `p += N` must scale N by
# sizeof(elem). heir1 rebuilds the binop with lval2.node after
# plnge2b runs, so the scaling has to live on lval2->node itself.
run_test "ptr_compound_add" "0064" 'int arr[10];
int get(int *p) { p += 2; return *p; }
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return get(arr);
}'

# `p -= N` similarly. Setup: pass &arr[3], subtract 2, should
# point at &arr[1] (10).
run_test "ptr_compound_sub" "000A" 'int arr[10];
int get(int *p) { p -= 2; return *p; }
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return get(&arr[3]);
}'

# Symmetric `N + p` (LHS const, RHS pointer) — also needs scaling.
# Plnge2b's LHS-const branch was modifying lval->const_val via cscale
# but never updating the AST literal, so 2+p emitted `inc hl; inc hl`
# (raw +2) instead of `ld bc,4; add hl,bc`.
run_test "const_plus_ptr" "0064" 'int arr[10];
int get(int *p) { return *(2 + p); }
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return get(arr);
}'

# `sizeof(arr)` was emitting `ld hl,N` twice — vconst() left in
# const.c::size_of alongside the AST literal. Walker emits from AST,
# so the vconst was redundant.
run_test "sizeof_int_arr" "0014" 'int arr[10];
int main(void) { return sizeof(arr); }'

# __builtin_offsetof had a worse bug: emitted via vconst but never
# built an AST node, so using it inside any larger expression
# segfaulted the compiler (NULL node deref).
run_test "offsetof_in_expr" "000C" 'struct S { int a; int b; long c; } s;
int main(void) {
    int x = __builtin_offsetof(struct S, b) + 10;
    return x;
}'

# Static initializer `&sym + N` was not scaling N by element size.
# `int *p = arr + 3` should yield &arr[3] (byte offset 6 on int[]) —
# the +/- branch in declinit.c just took the raw constexpr value as
# the byte offset.
run_test "static_init_ptr_plus" "0064" 'int arr[10];
int *p = arr + 2;
int main(void) {
    arr[0]=1; arr[1]=10; arr[2]=100; arr[3]=1000;
    return *p;
}'

# Same family: long * += N (stride 4). Function arg long * isolates
# the runtime ptr-arith path.
run_test "ptr_long_compound" "0064" 'long arr[10];
int get(long *p) { p += 2; return (int)*p; }
int main(void) {
    arr[0]=1L; arr[1]=10L; arr[2]=100L; arr[3]=1000L;
    return get(arr);
}'

# `long << int` runtime shift count — AST omits the legacy
# l_int2long_s widen before the shift helper. Verify the runtime
# math still works (1L << 3 = 8).
run_test "long_shift_runtime" "0008" 'long do_lshl(long x, int n) { return x << n; }
int main(void) { return (int)do_lshl(1L, 3); }'

# `*p++` and `*(++p)` on int* — pre/post step on pointer combined
# with deref. Must scale the increment by sizeof(elem).
run_test "ptr_post_step" "000A" 'int arr[5];
int read_next(int *p) { return *p++; }
int main(void) {
    arr[0]=10; arr[1]=20;
    return read_next(arr);
}'
run_test "ptr_pre_step" "0014" 'int arr[5];
int read_next(int *p) { return *(++p); }
int main(void) {
    arr[0]=10; arr[1]=20;
    return read_next(arr);
}'

# Same on long* — scale by 4.
run_test "ptr_post_step_long" "000A" 'long arr[5];
int read_next(long *p) { return (int)*p++; }
int main(void) {
    arr[0]=10L; arr[1]=20L;
    return read_next(arr);
}'

# _Accum16 (Q8.8 fixed-point) literal load — the AST walker was
# routing KIND_ACCUM16 through gen_load_constant_as_float (a 4-byte
# IEEE/MBF path) instead of load_fixed, so `_Accum a = 2.5k` emitted
# `ld hl, i_2+0; call dload` instead of `ld hl, 640`. Fix lives in
# cg2_literal's KIND_ACCUM16/32 branch. Test: 2.5k cast to int = 2.
run_test "accum16_literal" "0002" '_Accum a;
int main(void) { a = 2.5k; return (int)a; }'

# _Accum16 arithmetic — addition is just `add hl, de` since both
# operands share the same Q8.8 layout. 1.5k + 1.5k = 3.0k, cast to int = 3.
run_test "accum16_add" "0003" 'int main(void) {
    _Accum a = 1.5k;
    _Accum b = 1.5k;
    _Accum r = a + b;
    return (int)r;
}'

# Subtract: same Q8.8 layout, so `sub` is integer subtract.
run_test "accum16_sub" "0007" 'int main(void) {
    _Accum a = 10.0k;
    _Accum b = 3.0k;
    _Accum r = a - b;
    return (int)r;
}'

# Multiply: requires the l_fix16_mul helper.
run_test "accum16_mul" "0006" 'int main(void) {
    _Accum a = 3.0k;
    _Accum b = 2.0k;
    _Accum r = a * b;
    return (int)r;
}'

# Signed divide: l_fix16_divs.
run_test "accum16_div" "0004" 'int main(void) {
    _Accum a = 12.0k;
    _Accum b = 3.0k;
    _Accum r = a / b;
    return (int)r;
}'

# Negation: just `neg hl`-equivalent on the 16-bit value.
# -5.5 truncates toward zero on (int) cast = -5 = 0xFFFB.
run_test "accum16_neg" "FFFB" 'int main(void) {
    _Accum a = 5.5k;
    _Accum r = -a;
    return (int)r;
}'

# Mixed cast int → _Accum → int round-trip.
run_test "accum16_int_roundtrip" "002A" 'int main(void) {
    int i = 42;
    _Accum a = (_Accum)i;
    return (int)a;
}'

# Comparison — Q8.8 values compare like signed integers (because
# both operands share the same representation).
run_test "accum16_lt" "0001" 'int main(void) {
    _Accum a = 1.5k;
    _Accum b = 2.5k;
    return a < b;
}'
run_test "accum16_eq" "0001" 'int main(void) {
    _Accum a = 1.5k;
    _Accum b = 1.5k;
    return a == b;
}'

# Compound add — exercises the heir1 compound-assign rebuild path.
# (3.0 += 2.5) cast to int = 5.
run_test "accum16_compound_add" "0005" 'int main(void) {
    _Accum a = 3.0k;
    a += 2.5k;
    return (int)a;
}'

# Compound multiply: a *= b where a starts at 2.0k.
run_test "accum16_compound_mul" "0008" 'int main(void) {
    _Accum a = 2.0k;
    _Accum b = 4.0k;
    a *= b;
    return (int)a;
}'

# Array of _Accum: index scaling should be ×2 (Q8.8 is 2 bytes).
run_test "accum16_array_index" "0007" 'int main(void) {
    _Accum arr[4];
    arr[0] = 1.0k; arr[1] = 3.0k; arr[2] = 7.0k; arr[3] = 15.0k;
    return (int)arr[2];
}'

# Pointer to _Accum: deref + arithmetic.
run_test "accum16_via_ptr" "000A" 'int main(void) {
    _Accum vals[3];
    _Accum *p = vals;
    vals[0] = 4.0k; vals[1] = 10.0k; vals[2] = 99.0k;
    p++;
    return (int)*p;
}'

# Global _Accum read+write: the static-storage emit path.
run_test "accum16_global" "0009" '_Accum g;
int main(void) {
    g = 9.5k;
    return (int)g;
}'

# Runtime function argument (passes _Accum on the stack — Q8.8 = 2 bytes,
# same as a regular int in __smallc convention).
run_test "accum16_funcarg" "000C" '_Accum scale(_Accum x, _Accum f) { return x * f; }
int main(void) {
    return (int)scale(3.0k, 4.0k);
}'

# Truthiness — `if (accum_var)` should branch on zero/non-zero.
# 0.5k is non-zero so the `then` branch fires; return 7.
run_test "accum16_truthiness" "0007" 'int main(void) {
    _Accum a = 0.5k;
    if (a) return 7;
    return 0;
}'

# ---- _Float16 (IEEE half-precision) -------------------------
# Literal load: 1.5f16 encodes as 0x3E00 (sign=0, exp=15, mant=0.5)
# = 15872. Round-trip to int = 1.
run_test "float16_literal" "0001" '_Float16 a;
int main(void) { a = 1.5f16; return (int)a; }'

run_test "float16_add" "0006" 'int main(void) {
    _Float16 a = 2.5f16;
    _Float16 b = 3.5f16;
    _Float16 r = a + b;
    return (int)r;
}'

run_test "float16_sub" "0007" 'int main(void) {
    _Float16 a = 10.5f16;
    _Float16 b = 3.5f16;
    _Float16 r = a - b;
    return (int)r;
}'

run_test "float16_mul" "0006" 'int main(void) {
    _Float16 a = 3.0f16;
    _Float16 b = 2.0f16;
    _Float16 r = a * b;
    return (int)r;
}'

run_test "float16_div" "0004" 'int main(void) {
    _Float16 a = 12.0f16;
    _Float16 b = 3.0f16;
    _Float16 r = a / b;
    return (int)r;
}'

# Negation: IEEE half-precision flips the sign bit.
# -5.5f16 truncates to int as -5 = 0xFFFB.
run_test "float16_neg" "FFFB" 'int main(void) {
    _Float16 a = 5.5f16;
    _Float16 r = -a;
    return (int)r;
}'

# int → _Float16 → int round-trip.
run_test "float16_int_roundtrip" "002A" 'int main(void) {
    int i = 42;
    _Float16 a = (_Float16)i;
    return (int)a;
}'

# Comparison: lt and eq.
run_test "float16_lt" "0001" 'int main(void) {
    _Float16 a = 1.5f16;
    _Float16 b = 2.5f16;
    return a < b;
}'
run_test "float16_eq" "0001" 'int main(void) {
    _Float16 a = 1.5f16;
    _Float16 b = 1.5f16;
    return a == b;
}'

# Compound `+=` — exercises heir1 rebuild + l_f16_add.
run_test "float16_compound_add" "0005" 'int main(void) {
    _Float16 a = 3.0f16;
    a += 2.5f16;
    return (int)a;
}'

run_test "float16_compound_mul" "0008" 'int main(void) {
    _Float16 a = 2.0f16;
    _Float16 b = 4.0f16;
    a *= b;
    return (int)a;
}'

# Array indexing — element size 2 (FLOAT16 is 16-bit IEEE half).
run_test "float16_array_index" "0007" 'int main(void) {
    _Float16 arr[4];
    arr[0] = 1.0f16; arr[1] = 3.0f16; arr[2] = 7.0f16; arr[3] = 15.0f16;
    return (int)arr[2];
}'

# Pointer to _Float16 + post-step: scale by 2.
run_test "float16_via_ptr" "000A" 'int main(void) {
    _Float16 vals[3];
    _Float16 *p = vals;
    vals[0] = 4.0f16; vals[1] = 10.0f16; vals[2] = 99.0f16;
    p++;
    return (int)*p;
}'

# Global read/write.
run_test "float16_global" "0009" '_Float16 g;
int main(void) { g = 9.5f16; return (int)g; }'

# Function arg passing _Float16 (2 bytes, like an int) + return-type
# unwrap (A19 fix path: ensures `(int)scale_f16(...)` applies
# l_f16_f2sint via OP_CAST instead of returning raw bits).
run_test "float16_funcarg" "000C" '_Float16 scale(_Float16 x, _Float16 f) { return x * f; }
int main(void) { return (int)scale(3.0f16, 4.0f16); }'

# Truthiness — `if (f16_var)` branches on zero / non-zero.
run_test "float16_truthiness" "0007" 'int main(void) {
    _Float16 a = 0.5f16;
    if (a) return 7;
    return 0;
}'

# ---- long long (64-bit, __i64_acc) --------------------------
# Literal load: low 16 bits of 0x12345678LL = 0x5678. Larger values
# like 0x1122334455667788LL trigger the host's `long double`
# precision loss in the parser (warning: "On this host, 64 bit
# constants may not be correct") — pre-existing limitation, not an
# AST-codegen regression. Use a 32-bit-precise literal here.
run_test "llong_literal" "5678" 'long long g = 0x12345678LL;
int main(void) { return (int)g; }'

# Add two 64-bit constants where the result wraps past 32 bits —
# verifies the full 64-bit path, not just the low 32.
# 0x000000FFFFFFFF00LL + 0x0000000000000200LL = 0x0000010000000100LL
# (int) = low 16 bits = 0x0100 = 256.
run_test "llong_add_wraps" "0100" 'long long a = 0x000000FFFFFFFF00LL;
long long b = 0x0000000000000200LL;
int main(void) { return (int)(a + b); }'

run_test "llong_sub" "2EB8" 'int main(void) {
    long long a = 1000000LL;
    long long b = 5000LL;
    long long r = a - b;
    return (int)r;
}'  # 995000 = 0xF2EB8, low 16 = 0x2EB8

run_test "llong_mult" "C350" 'int main(void) {
    long long a = 10000LL;
    long long b = 5LL;
    return (int)(a * b);
}'  # 50000 = 0xC350

run_test "llong_div_signed" "0064" 'int main(void) {
    long long a = 1000000LL;
    long long b = 10000LL;
    return (int)(a / b);
}'  # 100 = 0x64

run_test "llong_mod" "0004" 'int main(void) {
    long long a = 1234567LL;
    long long b = 11LL;
    return (int)(a % b);
}'  # 1234567 % 11 = 4

# Bitwise — the AND should pick out bits across the 32-bit boundary.
# 0x123456789ABCDEF0 & 0x00000000FFFF0000 = 0x000000009ABC0000.
# (int)low16 = 0x0000.
run_test "llong_and" "0000" 'long long a = 0x123456789ABCDEF0LL;
long long b = 0x00000000FFFF0000LL;
int main(void) { return (int)(a & b); }'

# OR / XOR: 0x100000000LL | 0x42LL = 0x100000042 → low16 = 0x0042.
run_test "llong_or" "0042" 'long long a = 0x100000000LL;
long long b = 0x42LL;
int main(void) { return (int)(a | b); }'
# Use 32-bit-precise literals — anything > 53 bits suffers host
# `long double` precision loss in the parser.
run_test "llong_xor" "8888" 'long long a = 0x12345678LL;
long long b = 0x9ABCDEF0LL;
int main(void) { return (int)(a ^ b); }'  # 0x88888888, low16 = 0x8888

# Left shift past 32 bits — verifies the long-long shift helper
# (not the 32-bit one). 1LL << 40 = 0x10000000000.
# (int) low 16 = 0x0000.
run_test "llong_shl_40" "0000" 'long long a = 1LL;
int main(void) { return (int)(a << 40); }'

# 1LL << 8 = 256 = 0x100.
run_test "llong_shl_8" "0100" 'long long a = 1LL;
int main(void) { return (int)(a << 8); }'

# Right shift: 0xDEADBEEFCAFEBABELL >> 32 = 0xDEADBEEF → (int)0xBEEF.
run_test "llong_shr_32" "BEEF" 'long long a = 0xDEADBEEFCAFEBABELL;
int main(void) { return (int)(a >> 32); }'

# Negate: -100LL → 0xFFFFFFFFFFFFFF9C → (int)0xFF9C.
run_test "llong_neg" "FF9C" 'long long a = 100LL;
int main(void) { return (int)(-a); }'

# Comparison ==, !=, <, > on 64-bit.
run_test "llong_eq" "0001" 'long long a = 0x123456789ABCDEF0LL;
long long b = 0x123456789ABCDEF0LL;
int main(void) { return a == b; }'
run_test "llong_ne_high" "0001" 'long long a = 0x100000000LL;
long long b = 0LL;
int main(void) { return a != b; }'
run_test "llong_lt" "0001" 'int main(void) {
    long long a = 100LL;
    long long b = 200LL;
    return a < b;
}'
run_test "llong_gt_across_boundary" "0001" 'long long a = 0x100000000LL;
long long b = 0xFFFFFFFFLL;
int main(void) { return a > b; }'

# Cast int → long long → int round trip.
run_test "llong_int_roundtrip" "0539" 'int main(void) {
    int i = 1337;
    long long ll = (long long)i;
    return (int)ll;
}'

# Cast unsigned int → long long should zero-extend.
# 0xFFFF → 0x000000000000FFFFLL → low16 = 0xFFFF.
run_test "llong_uint_widen" "FFFF" 'int main(void) {
    unsigned int u = 0xFFFFu;
    long long ll = (long long)u;
    return (int)ll;
}'

# Cast signed int → long long should sign-extend negative.
# (long long)-1 = 0xFFFFFFFFFFFFFFFF; (int) → 0xFFFF.
run_test "llong_sint_widen_neg" "FFFF" 'int main(void) {
    int s = -1;
    long long ll = (long long)s;
    return (int)ll;
}'

# Compound assignment.
run_test "llong_compound_add" "0BC2" 'int main(void) {
    long long a = 1000LL;
    a += 2010LL;
    return (int)a;
}'  # 3010 = 0xBC2
run_test "llong_compound_mul" "01F4" 'int main(void) {
    long long a = 10LL;
    long long b = 50LL;
    a *= b;
    return (int)a;
}'  # 500 = 0x1F4

# Array of long long: stride 8 bytes.
run_test "llong_array_index" "01F4" 'int main(void) {
    long long arr[4];
    arr[0] = 1LL; arr[1] = 100LL; arr[2] = 500LL; arr[3] = 1234LL;
    return (int)arr[2];
}'  # 500 = 0x1F4

# Pointer to long long + post-step (stride 8).
run_test "llong_via_ptr" "03E8" 'int main(void) {
    long long vals[3];
    long long *p = vals;
    vals[0] = 1LL; vals[1] = 1000LL; vals[2] = 999999LL;
    p++;
    return (int)*p;
}'  # 1000 = 0x3E8

# Global long long.
run_test "llong_global" "0029" 'long long g;
int main(void) { g = 41LL; return (int)g; }'

# Function arg + return — A19 unwrap path: the call site casts
# the result via (int), needs the cast OP to see KIND_LONGLONG → KIND_INT.
run_test "llong_funcarg" "07D0" 'long long mul(long long x, long long f) { return x * f; }
int main(void) { return (int)mul(40LL, 50LL); }'  # 2000 = 0x7D0

# Truthiness on long long — both halves matter: a value with only
# the high half non-zero must still test as true.
run_test "llong_truthiness_high_only" "0007" 'int main(void) {
    long long a = 0x100000000LL;
    if (a) return 7;
    return 0;
}'
run_test "llong_truthiness_zero" "0001" 'int main(void) {
    long long a = 0LL;
    if (!a) return 1;
    return 0;
}'

# Mixed long long + int — int operand promotes to long long.
# 1000000LL + 50 → 1000050 → (int) = 0xF432.
run_test "llong_plus_int" "4272" 'int main(void) {
    long long a = 1000000LL;
    int b = 50;
    long long r = a + b;
    return (int)r;
}'  # 1000050 = 0xF4272, low 16 = 0x4272

# Logical && / || with long long operands. Both halves checked.
# a non-zero, b non-zero → 1. a zero → short-circuit → 0.
run_test "llong_andand" "0001" 'int main(void) {
    long long a = 0x100000000LL;
    long long b = 0x1LL;
    return a && b;
}'
run_test "llong_oror_first_zero" "0001" 'int main(void) {
    long long a = 0LL;
    long long b = 0x100000000LL;
    return a || b;
}'

# &p->member / &arr[i]: folded address-of shapes. Also guards the AST
# DSE pass: the read of `p` inside py'\''s initializer must keep
# `p = &s` alive (it was dropped as a dead store — the use counter
# skipped OP_ADDR subtrees wholesale).
run_test "addr_member_via_ptr" "0007" 'typedef struct { int x; int y; } P;
int main(void) { P s; P *p = &s; int *py = &p->y; *py = 7; return s.y; }'
run_test "addr_array_elem" "000B" 'int main(void) {
    int arr[4]; int i = 2; int *pa = &arr[i]; *pa = 11; return arr[2];
}'
run_test "addr_global_elem" "000D" 'int g_arr[5];
int main(void) { int i = 2; int *pg = &g_arr[i + 1]; *pg = 13; return g_arr[3]; }'

# Prototype param names differ from the definition: the retained
# prototype Type adopts the definition names at definition time, so
# loctab lookups by name resolve.
run_test "proto_param_rename" "0022" 'extern int f(int alpha, int beta);
int f(int a, int b) { return a * 10 + b; }
int main(void) { return f(3, 4); }'

# Switch dispatch routes (l_case table / inline char cp / l_long_case).
# The assign-then-break shape also guards the LICM single-def gate:
# the per-case `r = K` defs must NOT be hoisted above the dispatch
# (the case-label BBs have lower ids than the body fall-through BBs,
# so their BRs look like back-edges to the id-order loop finder).
run_test "switch_int_assign" "0003" 'int main(void) {
    int x = 30, r = 0;
    switch (x) {
    case 10: r = 1; break;
    case 20: r = 2; break;
    case 30: r = 3; break;
    case 40: r = 4; break;
    default: r = 9; break;
    }
    return r;
}'
run_test "switch_char_assign" "0014" 'int main(void) {
    char c = 98; int r = 0;
    switch (c) {
    case 97: r = 10; break;
    case 98: r = 20; break;
    case 99: r = 30; break;
    }
    return r;
}'
run_test "switch_long_assign" "0002" 'int main(void) {
    unsigned long v = 0x12340002UL; int r = 0;
    switch (v) {
    case 0x12340001UL: r = 1; break;
    case 0x12340002UL: r = 2; break;
    case 3UL:          r = 3; break;
    default:           r = 9; break;
    }
    return r;
}'
# Post-step fusion (IR_POSTSTEP): `while (n--)` / `*p++` / `arr[i++]`
# loop-carried post-steps lower to one slot read + writeback with the
# old value kept in HL — no frame-temp round trip. The md5 byte-copy
# loop shape, exercised with wraparound.
run_test "poststep_copy_loop" "019C" 'typedef struct { unsigned char in[8]; } C;
C g; unsigned char sbuf[8];
void copy(C *c, unsigned char *p, unsigned int n) {
    unsigned int mdi = 0;
    while (n--) { c->in[mdi++] = *p++; if (mdi == 8) mdi = 0; }
}
int main(void) {
    int k; unsigned char i;
    for (i = 0; i < 8; i++) sbuf[i] = (unsigned char)(i + 48);
    copy(&g, sbuf, 8);
    k = 0;
    for (i = 0; i < 8; i++) k += g.in[i];
    return k;
}'

# Long indirect stores, both fast paths: slot-resident value (address
# in DE, bytes walked through A) and DEHL-cached value (BC=low DE=high,
# HL takes the address) — no stack staging in either.
run_test "long_store_paths" "645C" 'typedef unsigned long UINT4;
UINT4 g4[3];
void wr(UINT4 *p, UINT4 v) { *p = v; }
void wr2(UINT4 *p) { *p = *p + 0x01020304UL; }
int main(void) {
    wr(&g4[1], 0xAABBCCDDUL);
    wr2(&g4[1]);
    return (int)((g4[1] >> 16) ^ (g4[1] & 0xFFFF));
}'

# Byte-pack idiom → wide load (ir_opt_pack_bytes): the little-endian
# ((long)b[k+3]<<24)|...|(long)b[k] gather collapses to one width-4
# LD_MEM. Verifies values through a pointer-based gather.
run_test "byte_pack_gather" "0042" 'typedef unsigned long UINT4;
void gather(UINT4 *out, unsigned char *b, int n) {
    int i, ii;
    for (i = 0, ii = 0; i < n; i++, ii += 4)
        out[i] = (((UINT4)b[ii+3]) << 24) | (((UINT4)b[ii+2]) << 16) |
                 (((UINT4)b[ii+1]) << 8)  | ((UINT4)b[ii]);
}
unsigned char src[8];
UINT4 dst2[2];
void dirty(void) { volatile int junk[16]; int i; for (i=0;i<16;i++) junk[i]=23130; }
int main(void) {
    int i;
    dirty();
    for (i = 0; i < 8; i++) src[i] = (unsigned char)(16 + i);
    gather(dst2, src, 2);
    if (dst2[0] != 0x13121110UL) return 1;
    if (dst2[1] != 0x17161514UL) return 2;
    return 0x42;
}'

# Struct decl-init via init_typed_region: field-by-field stores with
# zero-fill of uncovered members (C semantics). Mixed member widths,
# nested structs, char-array members from string literals.
run_test "struct_init_basic" "0031" 'typedef struct { int x; int y; } P;
int main(void) { P p = { 4, 9 }; return p.x * 10 + p.y; }'
run_test "struct_init_zero_fill" "0000" 'typedef struct { int x; int y; int z; } P;
void dirty(void) { volatile int junk[8]; int i; for (i = 0; i < 8; i++) junk[i] = 23130; }
int sub(void) { P p = { 1 }; return p.y | p.z; }
int main(void) { dirty(); return sub(); }'
run_test "struct_init_nested" "0315" 'typedef struct { int x; } In;
typedef struct { In a; int b; char c; } Out;
int main(void) { Out o = { {7}, 8, 9 }; return o.a.x * 100 + o.b * 10 + o.c; }'
run_test "struct_init_mixed_widths" "01A5" 'typedef struct { char tag; int big; long huge; } M;
int main(void) { M m = { 120, 300, 70000L }; return m.big + (int)(m.huge >> 16) + m.tag; }'
# Partial ARRAY init must zero-fill the tail (was a miscompile: the
# old flattener stored only the listed elements).
run_test "array_init_zero_fill" "0000" 'void dirty(void) { volatile int junk[8]; int i; for (i = 0; i < 8; i++) junk[i] = 23130; }
int sub(void) { int arr[4] = { 9 }; return arr[1] | arr[2] | arr[3]; }
int main(void) { dirty(); return sub(); }'

# Push-at-producer call args (IR_PUSH_ARG): every arg is pushed right
# after its producer, so arg temps live in HL/DEHL with no slot.
run_test "call_args_pushed" "0026" 'int add3(int a, int b, int c) { return a + b * 2 + c * 3; }
int main(void) { return add3(5, 6, 7); }'
# Nested call as a middle argument — inner call pushes/cleans its own
# args between the outer pushes (cur_sp_adjust nesting).
run_test "call_nested_arg" "0018" 'int twice(int x) { return x * 2; }
int sum3(int a, int b, int c) { return a + b + c; }
int main(void) { return sum3(1, twice(10), 3); }'
# Multi-BB arg expr (ternary) rolls back to the legacy slot path.
run_test "call_ternary_arg" "000F" 'int pick(int a, int b) { return a * 10 + b; }
int main(void) { int x = 5; return pick(x > 3 ? 1 : 2, x); }'
# PR_BC tenant across a pre-pushed call: BC is saved by the call'\''s
# first IR_PUSH_ARG (below the arg block) and popped after cleanup.
run_test "pr_bc_pre_push_call" "000F" 'int sink_g;
int sink(int v) { sink_g = v; return 0; }
int wrapped(int a, int b) { int sum = a + b; sink(sum); return sum + 1; }
int main(void) { return wrapped(3, 4) + sink_g; }'
# Fastcall callee definitions defer to the walker (IR prologue does
# not model the pushed-HL param) — execution must still be correct.
run_test "fastcall_callee" "0011" 'int dbl(int x) __z88dk_fastcall;
int dbl(int x) { return x * 2 + 1; }
int main(void) { return dbl(8); }'

# Switch inside a loop with a var live across the dispatch into the
# case bodies — l_case walks its table through BC, so PR_BC must not
# hold a value across a table-dispatch IR_SWITCH.
run_test "switch_in_loop_live" "003F" 'int main(void) {
    int total = 0;
    int i;
    for (i = 0; i < 4; i++) {
        int k = i * 10;
        switch (i) {
        case 0: total += k + 1; break;
        case 2: total += k + 2; break;
        default: total += k; break;
        }
    }
    return total;
}'

echo "smoke test:"
echo "  ok: $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do
        echo "  - $f"
    done
    exit 1
fi
