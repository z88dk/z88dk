#!/bin/bash
# sccz80 regression: type-mismatch diagnostics suite.
#
# Each case compiles a small C program and checks that the
# expected warning / error text appears exactly N times on stderr.
# Duplicate firings (parser + AST) would fail the count check.
# Also exercises negative cases (idioms that must NOT warn) to
# catch false positives.
#
# Usage: bash typecheck.sh
# override paths via env: COMPILER

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
[ -x "$COMPILER" ] || { echo "regression: COMPILER=$COMPILER not executable" >&2; exit 2; }

WORK="${WORK:-/tmp/sccz80_reg_typecheck}"
mkdir -p "$WORK"
rm -f "$WORK"/*.c "$WORK"/*.asm "$WORK"/*.stderr 2>/dev/null

ok=0
fail=0
failures=()

# Compile $src and check that $pattern appears exactly $count times in
# stderr. $count is enforced literally — duplicate firings (parser +
# AST) would fail the count check.
expect_warn() {
    local name="$1"
    local pattern="$2"
    local count="$3"
    local src="$4"
    local cfile="$WORK/$name.c"
    local stderr="$WORK/$name.stderr"

    printf '%s\n' "$src" > "$cfile"
    ( cd "$WORK" && "$COMPILER" -Wall "$name.c" 2> "$stderr" >/dev/null )
    local hits
    hits=$(grep -c -F "$pattern" "$stderr")
    if [ "$hits" -ne "$count" ]; then
        fail=$((fail+1))
        failures+=("$name: expected $count occurrence(s) of '$pattern', got $hits")
        return
    fi
    ok=$((ok+1))
}

# 1. signedness mismatch on /,*,%
expect_warn "signedness_div" "Operation on different signedness" 1 '
unsigned a; int b;
int main(void) { return a / b; }'

expect_warn "signedness_mod" "Operation on different signedness" 1 '
unsigned a; int b;
int main(void) { return a % b; }'

expect_warn "signedness_mult" "Operation on different signedness" 1 '
unsigned a; int b;
int main(void) { return a * b; }'

# Constant on one side silences (matches legacy "both non-const" gate).
expect_warn "signedness_const_silenced" "Operation on different signedness" 0 '
unsigned a;
int main(void) { return a / 2; }'

# Same signedness: silent.
expect_warn "signedness_same_silenced" "Operation on different signedness" 0 '
int a, b;
int main(void) { return a / b; }'

# 2. Comparison of pointer with non-pointer
expect_warn "cmp_ptr_int" "Comparison of pointer with non-pointer value" 1 '
int *p; int x;
int main(void) { return p == x; }'

# Comparing pointer to literal 0 (null check) is silent.
expect_warn "cmp_ptr_null_silenced" "Comparison of pointer with non-pointer value" 0 '
int *p;
int main(void) { return p == 0; }'

# 3. int + ptr (RHS pointer) — converting integer to pointer without cast
expect_warn "int_plus_ptr" "Converting integer type to pointer without cast" 1 '
int *p; int x;
int main(void) { int *r; r = x + p; return 0; }'

# ptr + int (LHS pointer): conventional indexing, silent.
expect_warn "ptr_plus_int_silenced" "Converting integer type to pointer without cast" 0 '
int *p;
int main(void) { int *r; r = p + 1; return 0; }'

# 4. ptr - ptr with mismatched element types
expect_warn "ptr_minus_ptr_mismatch" "Pointer arithmetic with non-matching types" 1 '
int *p; long *q;
int main(void) { return p - q; }'

# Matching types: silent.
expect_warn "ptr_minus_ptr_match_silenced" "Pointer arithmetic with non-matching types" 0 '
int *p; int *q;
int main(void) { return p - q; }'

# char-pointer either side: silent (legacy carve-out).
expect_warn "ptr_minus_charptr_silenced" "Pointer arithmetic with non-matching types" 0 '
int *p; char *q;
int main(void) { return p - q; }'

# 5. Narrowing far→near via explicit cast
expect_warn "narrow_far_to_near_cast" "Narrowing pointer from far to near" 1 '
int * __far fp;
int *np;
int main(void) { np = (int *)fp; return 0; }'

# 6. "Invalid pointer arithmetic" error — fires for pointer operand
# on a non-arithmetic / non-comparison binop. Migrated from plunge.c
# to ast_typecheck.
expect_warn "ptr_mult_error" "Invalid pointer arithmetic" 1 '
int *p;
int main(void) { return p * 5; }'

expect_warn "ptr_xor_error" "Invalid pointer arithmetic" 1 '
int *p; int x;
int main(void) { return (int)(p ^ x); }'

expect_warn "ptr_shl_error" "Invalid pointer arithmetic" 1 '
int *p;
int main(void) { return (int)(p << 2); }'

# Pointer + integer (legitimate indexing) is silent.
expect_warn "ptr_add_int_silenced" "Invalid pointer arithmetic" 0 '
int *p;
int main(void) { int *q = p + 5; return 0; }'

# Pointer == ptr / pointer == 0 (comparisons) are silent.
expect_warn "ptr_eq_silenced" "Invalid pointer arithmetic" 0 '
int *p; int *q;
int main(void) { return p == q; }'

# Sanity: no false positives on common idioms.
expect_warn "no_false_positives" "warning:" 0 '
int main(void) {
    int a = 10;
    int b = a / 2;
    int *p = 0;
    int *q;
    q = p + 1;
    char *s = "hello";
    if (p == 0) return 0;
    return b;
}'

echo "ast_typecheck regression:"
echo "  ok: $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do
        echo "  - $f"
    done
    exit 1
fi
