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

/* Compound assignment (`op=`) on long long destinations: local scalar,
 * local array (folded `a[0]` and indexed `a[i]`), global scalar/array, and
 * via a pointer. The aggregate stores once bailed with "OP_ASSIGN
 * aggregate/global elem width 8" — the offset-0 folded store (local and
 * global) now widens the RHS into the i64 acc and stores via l_i64_store
 * like the indexed / `*p` stores. Args are runtime ints so the ops don't
 * const-fold. */
long long cmp_g;
long long cmp_ga[3];

int ll_cmp_scalar(int a, int b)
{
    long long x = a;
    x += b; x *= 3; x -= 1; x <<= 1;
    return (int)x;
}
int ll_cmp_ops(int a)
{
    long long x = a;
    x %= 7;                 /* 1000 % 7  = 6   */
    x &= 0x0E;              /* 6 & 14    = 6   */
    x |= 0x01;              /* 6 | 1     = 7   */
    x ^= 0x05;              /* 7 ^ 5     = 2   */
    x >>= 1;               /* 2 >> 1    = 1   */
    return (int)x;
}
int ll_cmp_array(int a, int b)
{
    long long la[3];
    la[0] = a; la[0] *= b;          /* folded offset-0 compound */
    la[1] = a; la[1] += b; la[1] /= 2;
    return (int)(la[0] + la[1]);
}
int ll_cmp_global(int a, int b)
{
    cmp_g = a; cmp_g |= b; cmp_g ^= 1;
    cmp_ga[0] = a; cmp_ga[0] *= b;  /* global folded offset-0 */
    cmp_ga[2] = a; cmp_ga[2] += b;  /* global indexed */
    return (int)(cmp_g + cmp_ga[0] + cmp_ga[2]);
}
int ll_cmp_ptr(int a, int b)
{
    long long buf[2];
    long long *p = &buf[1];
    *p = a; *p -= b; *p *= 2;
    return (int)*p;
}

/* Plain long long aggregate store + load: array element (offset-0 folded and
 * indexed) and via a stepped pointer (`p++` stride 8). The element store once
 * bailed ("OP_ASSIGN aggregate elem width 8"); the read narrows back to int. */
int ll_array_rw(int a, int b, int c)
{
    long long arr[4];
    arr[0] = a; arr[1] = b; arr[2] = c; arr[3] = a + b + c;
    return (int)(arr[0] + arr[2] + arr[3]);
}
int ll_via_ptr(int a, int b, int c)
{
    long long vals[3];
    long long *p = vals;
    vals[0] = a; vals[1] = b; vals[2] = c;
    p++;                        /* stride 8 */
    return (int)*p;             /* vals[1] */
}

static void test_ll_aggregate_rw(void)
{
    Assert(ll_array_rw(10, 100, 500) == 1120,
           "long long array element store + load (folded + indexed)");
    Assert(ll_via_ptr(10, 1000, 7) == 1000,
           "long long *p after p++ (stride 8) reads the next element");
}

/* Nested narrowing cast `(wide)(narrow)x`: the inner cast must truncate before
 * the outer widens. heira() deferred an lvalue cast onto a single cast_type
 * slot, so the outer cast clobbered the inner — `(long long)(int)x` widened the
 * full long instead of the 16-bit int. Runtime args (no const-fold). */
long long nc_ll_of_int (long x) { return (long long)(int)x; }
long      nc_long_of_char(long x) { return (long)(char)x; }
int       nc_int_of_char (long x) { return (int)(char)x; }

static void test_nested_cast(void)
{
    /* low 16 bits, positive: high bits of the long are dropped */
    Assert(nc_ll_of_int(0x12345L) == 0x2345LL,
           "(long long)(int)x truncates to 16 bits before widening");
    /* (int) of 0xABCDE = 0xBCDE = -17186; sign-extends into the long long */
    Assert(nc_ll_of_int(0xABCDEL) == -17186LL,
           "(long long)(int)x sign-extends the truncated value");
    /* (char) truncates to 8 bits, then widen */
    Assert(nc_long_of_char(0x1234L) == 0x34L,   "(long)(char)x keeps 8 bits (positive)");
    Assert(nc_long_of_char(0x12FFL) == -1L,     "(long)(char)x sign-extends 0xFF");
    Assert(nc_int_of_char(0x12FFL)  == -1,      "(int)(char)x sign-extends 0xFF");
}

/* Host-independent signedness of integer constants at the sign boundary.
 * const.c keyed the implicit "exceeds-signed-range -> unsigned" promotion off
 * (uint64_t)(long double)const_val; casting a negative/out-of-range long double
 * to uint64_t is UB that diverges by host (x86 -> 0x8000…, ARM -> 0), so an
 * unsuffixed/LL hex constant at the top-bit boundary was typed unsigned on
 * some hosts and signed on others. The const-folder then picked logical vs
 * arithmetic shift accordingly, so `0x8000000000000000LL >> 1` folded to
 * 0x4000… (Intel) or 0xC000… (ARM). Now the typing reads the exact parsed
 * integer and a full-width 64-bit constant stays signed unless U-suffixed,
 * matching sccz80 and the signed runtime. */
static void test_ll_const_sign_typing(void)
{
    /* Signed LL: arithmetic (sign-extending) shift, like the signed runtime. */
    Assert((0x8000000000000000LL >> 1) == 0xC000000000000000LL,
           "signed 0x8000…LL >> 1 arithmetic-shifts (host-independent)");
    Assert((0x8000000000000000LL >> 1) != 0x4000000000000000LL,
           "signed 0x8000…LL >> 1 does NOT zero-fill");
    /* Explicit U suffix: logical (zero-filling) shift. */
    Assert((0x8000000000000000ULL >> 1) == 0x4000000000000000ULL,
           "unsigned 0x8000…ULL >> 1 zero-fills");
    /* The narrower-size unsigned-promotion rule still fires. */
    Assert(0xffff == -1,                        "0xffff is unsigned int (== -1)");
    Assert((int)0x8000 == (unsigned)0x8000,     "0x8000 unsigned-int boundary");
    Assert(3 * 0x2AAAAAAB == 0x80000001,        "0x80000001 unsigned long boundary");
}

static void test_ll_compound(void)
{
    Assert(ll_cmp_scalar(10, 5) == 88,  "ll scalar += *= -= <<=");
    Assert(ll_cmp_ops(1000)     == 1,   "ll scalar %= &= |= ^= >>=");
    Assert(ll_cmp_array(8, 4)   == 38,  "ll local array *= (folded) and += /= (indexed)");
    Assert(ll_cmp_global(7, 8)  == 85,  "ll global scalar |= ^= and array *= +=");
    Assert(ll_cmp_ptr(50, 8)    == 84,  "ll compound via pointer -= *=");
}

int main(int argc, char *argv[])
{
    suite_setup("long long unary ops (neg / complement)");
    suite_add_test(test_ll_negate);
    suite_add_test(test_ll_complement);
    suite_add_test(test_ll_signedness_cast);
    suite_add_test(test_ll_aggregate_rw);
    suite_add_test(test_nested_cast);
    suite_add_test(test_ll_const_sign_typing);
    suite_add_test(test_ll_compound);
    return suite_run();
}
