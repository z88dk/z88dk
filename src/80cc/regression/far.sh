#!/bin/bash
# sccz80 regression: __far pointer codegen comparison.
#
# For each test program:
#   1. Compile with sccz80 under test and with the legacy
#      z88dk-sccz80 (system binary) into separate .asm files.
#   2. Assemble both with z80asm.
#   3. Inspect the asm for the expected far-pointer runtime
#      helpers (lp_gint/lp_pint/lp_gchar/lp_pchar/lp_glong/
#      lp_plong/lp_gptr/lp_pptr/l_far_mapaddr/l_farcall). Failing:
#      an expected helper missing, OR the near equivalent (l_gint
#      etc.) appearing where far was required.
#   4. Optionally diff the two asm outputs side-by-side (--diff).
#
# Usage:
#   bash far.sh           # summary only
#   bash far.sh --diff    # also show per-test asm diffs
#   override paths via env: COMPILER, LEGACY_SCCZ80, Z80ASM, Z88DK_LIB

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

# This suite needs the legacy sccz80 too. Skip cleanly if absent.
if ! command -v "$LEGACY_SCCZ80" >/dev/null 2>&1 && [ ! -x "$LEGACY_SCCZ80" ]; then
    echo "far: LEGACY_SCCZ80=$LEGACY_SCCZ80 not found, skipping" >&2
    exit 0
fi

AST_COMPILER="$COMPILER"
LIBS=("-I$Z88DK_LIB" "-L$Z88DK_LIB/clibs")
WORK="${WORK:-/tmp/sccz80_reg_far}"

show_diff=0
for arg in "$@"; do
    case "$arg" in
        --diff) show_diff=1 ;;
    esac
done

mkdir -p "$WORK"
rm -f "$WORK"/*.c "$WORK"/*.asm "$WORK"/*.o

total=0
ok=0
fail=0
failures=()

# run_far_test NAME EXPECTED_HELPERS_CSV C_SOURCE [MODE]
#   NAME      : test identifier (becomes a filename)
#   EXPECTED  : comma-separated list of asm helpers that MUST appear
#               in the asm output (e.g. "lp_gint,lp_pint"). The test
#               fails if any expected helper is missing from either
#               compiler's output, OR if the *near* equivalent appears
#               in place of the far one in AST mode.
#   C_SOURCE  : C program text
#   MODE      : optional; "ast_only" tolerates the legacy compiler
#               being missing the expected helpers (e.g. for fixes
#               that exist in the current sccz80 but haven't been
#               back-ported to the shipping z88dk-sccz80 binary).
run_far_test() {
    local name="$1"
    local expected="$2"
    local src="$3"
    local mode="${4:-both}"
    local cfile="$WORK/$name.c"
    local ast_asm="$WORK/$name.ast.asm"
    local leg_asm="$WORK/$name.legacy.asm"
    total=$((total+1))

    printf '# 1 "%s.c"\n%s\n' "$name" "$src" > "$cfile"

    # Legacy compile
    local leg_status="ok"
    rm -f "$WORK/$name.asm"
    if ( cd "$WORK" && "$LEGACY_SCCZ80" "$name.c" >/dev/null 2>&1 ) ; then
        cp "$WORK/$name.asm" "$leg_asm"
    else
        leg_status="compile-failed"
    fi

    # AST compile
    local ast_status="ok"
    rm -f "$WORK/$name.asm"
    if ( cd "$WORK" && "$AST_COMPILER" "$name.c" >/dev/null 2>&1 ) ; then
        cp "$WORK/$name.asm" "$ast_asm"
    else
        ast_status="compile-failed"
    fi

    if [ "$leg_status" != "ok" ] || [ "$ast_status" != "ok" ] ; then
        fail=$((fail+1))
        failures+=("$name: legacy=$leg_status ast=$ast_status")
        return
    fi

    # Assemble both
    local leg_asm_ok=1 ast_asm_ok=1
    ( cd "$WORK" && "$Z80ASM" -b "${LIBS[@]}" -lz80_crt0 -lz80_clib \
        "$leg_asm" -o "$WORK/$name.legacy.bin" >/dev/null 2>&1 ) || leg_asm_ok=0
    ( cd "$WORK" && "$Z80ASM" -b "${LIBS[@]}" -lz80_crt0 -lz80_clib \
        "$ast_asm" -o "$WORK/$name.ast.bin"    >/dev/null 2>&1 ) || ast_asm_ok=0

    # Check expected helpers in BOTH outputs. sccz80 emits these as
    # `call\thelper` in the asm (the C-side `callrts()` is the C name
    # for the emitter, not the asm mnemonic). Match \tcall\t<helper>\b.
    local missing_ast=() missing_leg=()
    IFS=',' read -ra helpers <<< "$expected"
    for h in "${helpers[@]}"; do
        grep -qE $'\tcall\t'"$h\\b" "$ast_asm" || missing_ast+=("$h")
        grep -qE $'\tcall\t'"$h\\b" "$leg_asm" || missing_leg+=("$h")
    done

    # Flag the common AST regression: emitted near-pointer helper
    # where the legacy emitted the far variant. Distinct from "missing"
    # so the diagnostic is actionable.
    local near_for_far=()
    for pair in "lp_gint:l_gint" "lp_pint:l_pint" \
                "lp_gchar:l_gchar" "lp_pchar:l_pchar" \
                "lp_guchar:l_guchar" \
                "lp_glong:l_glong" "lp_plong:l_plong" \
                "lp_gptr:l_gptr" "lp_pptr:l_pptr"; do
        local far="${pair%%:*}"
        local near="${pair##*:}"
        case ",$expected," in *",$far,"*)
            if ! grep -qE $'\tcall\t'"$far\\b" "$ast_asm" \
               && grep -qE $'\tcall\t'"$near\\b" "$ast_asm" ; then
                near_for_far+=("$near (expected $far)")
            fi
        esac
    done

    # Pass/fail is based on asm content, not linkability — the test
    # programs are deliberately minimal and link-failures are expected
    # (no main, no harness). Report assembly status as info only.
    # `ast_only` mode demotes legacy-missing helpers to info too —
    # used for fixes that exist in the current sccz80 but not in the
    # shipping z88dk-sccz80 binary.
    local notes=() info=()
    if [ ${#missing_leg[@]} -gt 0 ]; then
        if [ "$mode" = "ast_only" ]; then
            info+=("legacy-missing: ${missing_leg[*]}")
        else
            notes+=("legacy-missing: ${missing_leg[*]}")
        fi
    fi
    [ ${#missing_ast[@]} -gt 0 ] && notes+=("ast-missing: ${missing_ast[*]}")
    [ ${#near_for_far[@]} -gt 0 ] && notes+=("ast-near-for-far: ${near_for_far[*]}")
    [ $leg_asm_ok -eq 0 ] && info+=("legacy-asm-failed")
    [ $ast_asm_ok -eq 0 ] && info+=("ast-asm-failed")

    if [ ${#notes[@]} -eq 0 ]; then
        ok=$((ok+1))
        if [ ${#info[@]} -gt 0 ] && [ $show_diff -eq 1 ]; then
            echo "  info $name: ${info[*]}"
        fi
    else
        fail=$((fail+1))
        local all_notes="${notes[*]}"
        [ ${#info[@]} -gt 0 ] && all_notes="$all_notes (info: ${info[*]})"
        failures+=("$name: $all_notes")
    fi

    if [ $show_diff -eq 1 ]; then
        echo "===== diff: $name ====="
        diff -u "$leg_asm" "$ast_asm" || true
        echo
    fi
}

# ---- Tests ----------------------------------------------------------

# 1. Read a 16-bit value through a far pointer.
run_far_test "far_read_int" "lp_gint" '
int *__far p;
int read_via_far(void) { return *p; }
'

# 2. Write a 16-bit value through a far pointer.
run_far_test "far_write_int" "lp_pint" '
int *__far p;
void write_via_far(int v) { *p = v; }
'

# 3. Read an unsigned char through a far pointer.
run_far_test "far_read_uchar" "lp_guchar" '
unsigned char *__far p;
unsigned char read_via_far(void) { return *p; }
'

# 4. Write a char through a far pointer.
run_far_test "far_write_char" "lp_pchar" '
char *__far p;
void write_via_far(char v) { *p = v; }
'

# 5. Read a long through a far pointer.
run_far_test "far_read_long" "lp_glong" '
long *__far p;
long read_via_far(void) { return *p; }
'

# 6. Write a long through a far pointer.
run_far_test "far_write_long" "lp_plong" '
long *__far p;
void write_via_far(long v) { *p = v; }
'

# 7. Read a (near) pointer through a far pointer. Legacy uses lp_gint
#    here — pointers are 2 bytes, same path as int reads.
run_far_test "far_read_ptr" "lp_gint" '
int **__far p;
int *read_via_far(void) { return *p; }
'

# 8. Pointer arithmetic on a far pointer (post-increment).
run_far_test "far_post_inc" "lp_gint" '
int *__far p;
int next(void) { return *p++; }
'

# 9. Array indexing through a far pointer with a non-const index.
run_far_test "far_array_index" "lp_gint" '
int *__far p;
int read_idx(int i) { return p[i]; }
'

# 10. Array indexing through a far pointer with a const index.
run_far_test "far_array_const_index" "lp_gint" '
int *__far p;
int read_idx5(void) { return p[5]; }
'

# 11. Struct member access through a far pointer.
run_far_test "far_struct_member" "lp_gint" '
struct s { int a; int b; };
struct s *__far p;
int read_member(void) { return p->b; }
'

# 12. Far-pointer parameter to a function.
run_far_test "far_param" "lp_gint" '
int read_via(int *__far q) { return *q; }
'

# 13. Read a `__banked` global. Triggers `l_far_mapaddr` to compute the
#     24-bit address before the `lp_gint` load. Distinct from the far-
#     pointer cases above: here the *variable itself* is in far memory
#     (FARACC on the symbol's ctype), not a pointer pointing into it.
run_far_test "far_banked_read" "l_far_mapaddr,lp_gint" '
__banked int banked_x;
int read_banked(void) { return banked_x; }
'

# 14. Write a `__banked` global. Pairs `l_far_mapaddr` with `lp_pint`.
#     The shipping z88dk-sccz80 binary's `gen_store_static` doesn't
#     honour FARACC for writes — that's a pre-existing legacy gap.
#     The current sccz80 fixes this, so `ast_only` mode tolerates the
#     legacy compiler missing the helpers.
run_far_test "far_banked_int_write" "l_far_mapaddr,lp_pint" '
__banked int banked_x;
void write_banked(int v) { banked_x = v; }
' "ast_only"

# 15. Write a `__banked` char global. Pairs `l_far_mapaddr` with
#     `lp_pchar`. Same legacy gap as above — `ast_only`.
run_far_test "far_banked_char_write" "l_far_mapaddr,lp_pchar" '
__banked char banked_x;
void write_banked(char v) { banked_x = v; }
' "ast_only"

# 16. Address-of a `__banked` global (`p = &banked_x`). Just the
#     mapaddr call — no further load/store.
run_far_test "far_banked_addr" "l_far_mapaddr" '
__banked int banked_x;
int *__far ptr;
void take_addr(void) { ptr = &banked_x; }
'

# ---- Report ---------------------------------------------------------

echo "=== __far comparison results ==="
echo "  total:    $total"
echo "  ok:       $ok"
echo "  fail:     $fail"
if [ $fail -gt 0 ]; then
    echo
    echo "Failures:"
    for f in "${failures[@]}"; do
        echo "  - $f"
    done
fi
echo
echo "Asm files in $WORK/<name>.{ast,legacy}.asm"
echo "Use --diff to see per-test asm differences."
