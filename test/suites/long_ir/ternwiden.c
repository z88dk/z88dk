/* Two kind/width builder bugs surfaced by umaxd's fp compile (both mode-
   independent; sp masked them, fp's register-only allocation turned them into
   compile aborts or wrong values).

   1. Ternary result hint. AST_TERNARY stamped the caller's HINT vreg's kind/
      width to the ternary's own type. When the hint was a live variable of a
      DIFFERENT type — `long v = cond ? (i - j) : 0`, v (long) passed as the
      hint for an int-typed ternary — the arms stored a 2-byte int straight into
      the 4-byte local. A later consistency pass restored v to long/width-4 while
      the arm binop kept int operands, so the widened read hit a register-only
      DEHL with no slot and aborted (umaxd.c:64). Now the ternary reuses the hint
      only when its type already matches, else a fresh temp the caller widens.

   2. Array indexed by a wider integer. `char a[]; a[longvar]` is 16-bit address
      arithmetic, but is_ptrish covered KIND_PTR only — for KIND_ARRAY the mixed-
      width converge WIDENED the array base to the long index width, building a
      bogus 4-byte "address" that then aborted a register-only DEHL read in fp
      (umaxd.c:103). Now array bases converge the index DOWN to the base width.

   Values kept small so truncation/widening — not overflow — is what's tested.
   Passes sp AND fp; the residual umaxd fp miscompile is a separate lowering
   bug (register-only long operand eviction), not one of these. */
#include "test.h"

char  ba[64];
long  gk;

/* Ternary whose int-typed arms feed a long target (bug #1). */
static long tern_to_long(int c, int i, int j)
{
    long v;
    v = c ? i - j : 0;   /* v is long; the ternary/arms are int */
    return v;
}

static void test_tern_widen(void)
{
    Assert(tern_to_long(1, 7, 3)  == 4L,    "ternary int arm -> long (true)");
    Assert(tern_to_long(0, 7, 3)  == 0L,    "ternary int arm -> long (false)");
    Assert(tern_to_long(1, 3, 10) == -7L,   "ternary negative int arm -> long (sign)");
    Assert(tern_to_long(1, 100, 1) == 99L,  "ternary int arm -> long (value)");
}

/* char array indexed by a long (bug #2). */
static void test_array_long_index(void)
{
    long k;
    for (k = 0; k < 8; k++) ba[k] = (char)(k + 10);
    gk = 3;  Assert(ba[gk]      == 13, "char[long global idx]");
    k  = 5;  Assert(ba[k]       == 15, "char[long local idx]");
    gk = 1;  Assert(ba[gk + 2]  == 13, "char[long idx + const]");
    /* index computed as a long subtraction, result fits 16 bits */
    k  = 6;  Assert(ba[k - 2]   == 14, "char[long idx - const]");
}

int main(int argc, char *argv[])
{
    suite_setup("ternary/array kind-width widening (umaxd builder bugs)");
    suite_add_test(test_tern_widen);
    suite_add_test(test_array_long_index);
    return suite_run();
}
