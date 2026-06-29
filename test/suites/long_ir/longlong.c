/* Long long (width-8 __i64_acc) unary ops: negate and bitwise complement.
 *
 * There is no width-8 lowering for IR_NEG / IR_NOT (gen_neg / gen_not only
 * handle 2- and 4-byte values), so `-x` / `~x` on a long long must lower via
 * the i64 accumulator helpers l_i64_neg / l_i64_com, NOT emit IR_NEG/IR_NOT.
 * Two bugs lived here:
 *   1. ir_build's OP_NEG/OP_COMP set the result vreg's width to 8 but left
 *      its KIND unset (KIND_CHAR default). The width-8 slot copy then keyed
 *      acc_prim on the kind and picked the DOUBLE dload/dstore — dragging in
 *      init_floatpack (the mult suite failed to LINK), and moving only a
 *      partial value.
 *   2. Even with the kind fixed, IR_NEG/IR_NOT at width 8 fell through to the
 *      16-bit path: it negated/complemented only the low word and read 8
 *      bytes back, leaving the top 6 bytes garbage.
 * Both are exercised below: helpers take int args (no const-fold), widen to
 * long long, and the asserts read the HIGH half via a >>40 shift and feed a
 * negate into a multiply — a low-word-only op corrupts both. This is the
 * sccz80 mult suite's test_mult_longlong reduced; its own binary because
 * long_ir.c is at the MSX 64K ceiling. */
#include "test.h"

int  ll_neg   (int a)        { long long x = a; return (int)(-x); }
int  ll_neghi (int a)        { long long x = a; x = -x; return (int)(x >> 40); }
int  ll_negmul(int a, int b) { long long x = a; return (int)(-x * (long long)b); }
int  ll_com   (int a)        { long long x = a; return (int)(~x); }
int  ll_comhi (int a)        { long long x = a; x = ~x; return (int)(x >> 40); }

static void test_ll_negate(void)
{
    Assert(ll_neg(5)     == -5,  "-(ll)5 == -5");
    Assert(ll_neg(-5)    ==  5,  "-(ll)-5 == 5");
    Assert(ll_neg(0)     ==  0,  "-(ll)0 == 0");
    /* -5 = 0xFFFFFFFFFFFFFFFB: the top bytes must be 0xFF (>>40 == -1). A
       low-word-only negate leaves them 0 → >>40 == 0. */
    Assert(ll_neghi(5)   == -1,  "negate sets the high 48 bits (sign)");
    Assert(ll_neghi(-5)  ==  0,  "negate of negative clears high bits");
    /* -c * d: the negated operand feeds the i64 multiply (the mult-suite
       failure). A garbage high half gives a wildly wrong product. */
    Assert(ll_negmul(3, 5)   == -15, "(-ll 3) * 5 == -15");
    Assert(ll_negmul(-3, 5)  ==  15, "(-ll -3) * 5 == 15");
    Assert(ll_negmul(7, -9)  ==  63, "(-ll 7) * -9 == 63");
}

static void test_ll_complement(void)
{
    Assert(ll_com(5)     == -6,  "~(ll)5 == -6");
    Assert(ll_com(0)     == -1,  "~(ll)0 == -1");
    Assert(ll_com(-1)    ==  0,  "~(ll)-1 == 0");
    /* ~0 = -1 = all ones: >>40 == -1. A low-word-only complement leaves the
       high bytes as the original (0) → >>40 == 0. */
    Assert(ll_comhi(0)   == -1,  "complement sets the high 48 bits");
    Assert(ll_comhi(-1)  ==  0,  "~(-1) high bits clear");
}

/* Explicit cast between long long and unsigned long long is a same-width
   signedness reinterpret — all 64 bits must survive. ir_build's OP_CAST
   wrongly matched the int->ll branch (is_acc_int(dst) with no src guard) and
   fed the already-width-8 value to l_i64_{u,s}int2i64, which reads only the
   low 16 bits → 0 when the low word is 0. The args are runtime params (no
   const-fold), so the explicit cast lowering is what's exercised. */
unsigned long long ull_roundtrip(unsigned long long u) { return (unsigned long long)(long long)u; }
long long          ll_div_cast (unsigned long long u) { return (long long)(u / 3); }
long long          ll_shr_cast (unsigned long long u) { return (long long)(u >> 4); }
int                ull_lt      (unsigned long long a, unsigned long long b) { return a < b; }

static void test_ll_signedness_cast(void)
{
    /* low word 0, high word set — the exact case that folded to 0 */
    Assert(ull_roundtrip(0xFFFFFFFF00000000ULL) == 0xFFFFFFFF00000000ULL,
           "ull->ll->ull preserves all 64 bits");
    Assert((long long)ull_roundtrip(0x8000000000000000ULL) == (long long)0x8000000000000000ULL,
           "ull->ll->ull of sign bit");
    Assert(ll_div_cast(0xFFFFFFFF00000000ULL) == 0x5555555500000000LL,
           "(long long)(ull/3) keeps the high half");
    Assert(ll_shr_cast(0xFFFFFFFF00000000ULL) == 0x0FFFFFFFF0000000LL,
           "(long long)(ull>>4) keeps the high half");
    /* unsigned ll compare: 0xFF..>5 is true unsigned (would be <0 signed) */
    Assert(ull_lt(5ULL, 0xFFFFFFFF00000000ULL) == 1, "unsigned ll 5 < 0xFFFFFFFF00000000");
    Assert(ull_lt(0xFFFFFFFF00000000ULL, 5ULL) == 0, "unsigned ll !(big < 5)");
}

int main(int argc, char *argv[])
{
    suite_setup("long long unary ops (neg / complement)");
    suite_add_test(test_ll_negate);
    suite_add_test(test_ll_complement);
    suite_add_test(test_ll_signedness_cast);
    return suite_run();
}
