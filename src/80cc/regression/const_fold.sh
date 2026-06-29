#!/bin/bash
# sccz80 regression: const-fold parity against the legacy compiler.
#
# Compiles a const-heavy fixture with both the sccz80 under test
# and the legacy z88dk-sccz80, then verifies that for each fold
# target the same compile-time-resolved value is emitted. Scans
# each .asm for `ld hl,N ;const` inside the named function body
# and compares values function-by-function.
#
# Usage:
#   bash const_fold.sh           # summary only
#   bash const_fold.sh --diff    # full asm diff per fixture
#   override paths via env: COMPILER, LEGACY_SCCZ80, UCPP, FIXTURE

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
[ -x "$COMPILER" ] || { echo "regression: COMPILER=$COMPILER not executable" >&2; exit 2; }
if ! command -v "$LEGACY_SCCZ80" >/dev/null 2>&1 && [ ! -x "$LEGACY_SCCZ80" ]; then
    echo "const_fold: LEGACY_SCCZ80=$LEGACY_SCCZ80 not found, skipping" >&2
    exit 0
fi

AST_COMPILER="$COMPILER"
WORK="${WORK:-/tmp/sccz80_reg_const_fold}"

show_diff=0
for arg in "$@"; do
    case "$arg" in
        --diff) show_diff=1 ;;
    esac
done

mkdir -p "$WORK"
rm -f "$WORK"/*.c "$WORK"/*.i "$WORK"/*.asm

SRC="${FIXTURE:-$REG_DIR/fixtures/cf_stress.c}"
cp "$SRC" "$WORK/"

# AST sccz80 popens ucpp itself — feed the .c directly.
( cd "$WORK" && "$AST_COMPILER" cf_stress.c 2>/dev/null )
mv "$WORK/cf_stress.asm" "$WORK/cf_stress.ast.asm"

# Legacy sccz80 has no internal preprocessor — pre-process for it.
"$UCPP" "$WORK/cf_stress.c" > "$WORK/cf_stress.i" 2>/dev/null
( cd "$WORK" && "$LEGACY_SCCZ80" cf_stress.i 2>/dev/null )
mv "$WORK/cf_stress.asm" "$WORK/cf_stress.legacy.asm"

# Each function under test should fold to a single `ld hl,N` (or
# similar for 32-bit). Extract per-function values and compare.
extract_funcs() {
    awk '
        /^\._/ { sub("^\\._",""); sub(":",""); fn=$1; next }
        /^\.\w/ { fn="" }   # other label types reset
        fn && /;const/ {
            # capture the loaded const value
            if (match($0,/[0-9]+/)) {
                val = substr($0, RSTART, RLENGTH);
                # only first const per fn (subsequent are typically
                # related to call argument fetches, not the fold result)
                if (!(fn in seen)) { print fn"="val; seen[fn]=1 }
            }
        }
    ' "$1"
}

ast_vals=$(extract_funcs "$WORK/cf_stress.ast.asm")
legacy_vals=$(extract_funcs "$WORK/cf_stress.legacy.asm")

ok=0; fail=0; better=0; failures=()
all_fns=$(printf "%s\n%s\n" "$ast_vals" "$legacy_vals" | cut -d= -f1 | sort -u | grep -v '^$')

# Functions where ast-codegen is expected to produce a *better* result
# than legacy (e.g. via const-propagation that legacy doesn't do).
EXPECTED_BETTER="const_prop"

is_expected_better() {
    case " $EXPECTED_BETTER " in *" $1 "*) return 0 ;; esac
    return 1
}

for fn in $all_fns; do
    a=$(printf "%s\n" "$ast_vals"    | grep "^$fn=" | head -1 | cut -d= -f2)
    l=$(printf "%s\n" "$legacy_vals" | grep "^$fn=" | head -1 | cut -d= -f2)
    if [ -z "$a" ] || [ -z "$l" ]; then
        fail=$((fail+1)); failures+=("$fn: missing const load (ast=$a legacy=$l)")
    elif [ "$a" != "$l" ]; then
        if is_expected_better "$fn"; then
            better=$((better+1))
        else
            fail=$((fail+1)); failures+=("$fn: ast=$a vs legacy=$l")
        fi
    else
        ok=$((ok+1))
    fi
done

echo "Const-fold parity (ast vs z88dk-sccz80):"
echo "  ok:                $ok"
echo "  ast better (ok):   $better"
echo "  fail:              $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do
        echo "  - $f"
    done
fi

if [ $show_diff -eq 1 ]; then
    echo ""
    echo "=== full diff (excluding timestamps) ==="
    diff <(grep -v "compile time" "$WORK/cf_stress.ast.asm") \
         <(grep -v "compile time" "$WORK/cf_stress.legacy.asm")
fi

[ $fail -eq 0 ]
