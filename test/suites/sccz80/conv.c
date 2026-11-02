/* Runtime promotions that the constant fold does not see.
 * A char promotes before unary - and unary ~.
 * A far pointer compare uses 24 bits.
 * A pointer difference is a signed element count.
 * An int widens before a long constant is added.
 */
#include "test.h"
#include <stdio.h>
#include <string.h>

struct S5 { char a[5]; };

static volatile unsigned char vuc = 200;
static volatile unsigned char vff = 255;
static volatile unsigned char vone = 1;
static volatile unsigned char vzero = 0;
static volatile int vd = 2;
static volatile signed char vsc = (signed char)0x80;
static volatile long vl = 200;
static volatile int vi = 1;
static volatile unsigned int vu = 65535;
static volatile int vm1 = -1;

static int iarr[8];
static char carr[8];
static long larr[4];
static int *volatile ip;
static int *volatile iq;
static struct S5 *volatile spa;
static struct S5 *volatile spb;
static char *__far volatile vfp;

static long neg_uc(unsigned char c) { return (long)-c; }
static long com_uc(unsigned char c) { return (long)~c; }
static unsigned char trunc_not(unsigned char c) { return (unsigned char)~c; }
static unsigned char trunc_neg(unsigned char c) { return (unsigned char)-c; }
static unsigned char trunc_not_i(unsigned char c) { return ~c; }
static unsigned char trunc_neg_i(unsigned char c) { return -c; }
static unsigned char trunc_neg_s(signed char c) { return (unsigned char)-c; }
static unsigned char take_uc(unsigned char c) { return c; }
static signed char trunc_neg_sc(signed char c) { return -c; }
static unsigned char init_neg(unsigned char c)
{
    unsigned char z = -c;
    return z;
}
static unsigned char tern_unop(unsigned char c, unsigned char x)
{
    return c ? ~x : -x;
}
/* A later divide, shift, or subscript must see the promoted unary.
   The char conversion is only the stored byte. */
static int tern_neg_div(unsigned char c, unsigned char x, int d)
{
    return (c ? -x : 1) / d;
}
static unsigned char tern_neg_div_uc(unsigned char c, unsigned char x, int d)
{
    return (c ? -x : 1) / d;
}
static unsigned char tern_com_div_arg(unsigned char c, unsigned char x, int d)
{
    return take_uc((c ? ~x : 0) / d);
}
static unsigned char tern_com_shift(unsigned char c, unsigned char x)
{
    return (c ? ~x : 1) >> 1;
}
static unsigned char subarr[512];
static unsigned char sub_com(unsigned char u)
{
    unsigned char *p = subarr + 256;
    unsigned char x = p[~u];
    return x;
}
/* Both arms are promoted. The false arm's char type must not win. */
static unsigned char tern_shift_same(unsigned char c, unsigned char x)
{
    return (c ? ~x : x) >> 1;
}
static int tern_both_shl(unsigned char c, unsigned char x)
{
    return (c ? x : x) << 1;
}
static int tern_sc_shr(unsigned char c, signed char x)
{
    return (c ? x : x) >> 1;
}
static int tern_sc_shl(unsigned char c, signed char x)
{
    return (c ? x : x) << 1;
}
static unsigned long tern_ul_shr(unsigned char c, unsigned long u, long s)
{
    return (c ? u : s) >> 1;
}
static int tern_ui_si(unsigned char c, unsigned int u, int s)
{
    return (c ? u : s) >> 1;
}
static int tern_add_shr(unsigned char c, unsigned char a, unsigned char b)
{
    return (c ? (a + b) : a) >> 1;
}
static unsigned char tern_sub(unsigned char c, unsigned char x)
{
    unsigned char *p = subarr + 256;
    return p[c ? ~x : x];
}
static int add_shr(unsigned char a, unsigned char b)
{
    return (a + b) >> 1;
}
static int uc_plus_shr(unsigned char a, int b)
{
    return (a + b) >> 1;
}
static int uc_lt_neg(unsigned char a, int b)
{
    return a < b;
}
static int shr_u_count(int a, unsigned n)
{
    return a >> n;
}
static int sc_shr_u(signed char a, unsigned n)
{
    return a >> n;
}
static long sl_shr_u(long a, unsigned n)
{
    return a >> n;
}
static unsigned long shr_wide_count(int a, unsigned long n)
{
    return a >> n;
}
static int lt_long_u(unsigned u)
{
    return (-1L) < u;
}
#ifndef __8085
static int shr_c_ull(int a)
{
    return a >> 1ULL;
}
static int shr_c0_ull(int a)
{
    return a >> 0ULL;
}
static int shl_c_ull(int a)
{
    return a << 1ULL;
}
static long shr_c_ll(long a)
{
    return a >> 1LL;
}
static int shr_ull_rt(int a, unsigned long long n)
{
    return a >> n;
}
#endif
static int cmp_arm(unsigned char c, unsigned int a, unsigned int b)
{
    return c ? (a < b) : 7;
}
static int cmp_both(unsigned char c, unsigned int a, unsigned int b,
                    unsigned int d, unsigned int e)
{
    return c ? (a < b) : (d < e);
}
#ifndef __8085
static int ull_hi_logical(unsigned char c, unsigned long long u, long long s)
{
    unsigned long long v = (c ? u : s) >> 1;
    unsigned long hi;

    memcpy(&hi, (unsigned char *)&v + 4, 4);
    return hi == 2147483647UL;
}
static int mix_ll_logical(long long a, unsigned long long b)
{
    unsigned long long v = (a + b) >> 1;
    unsigned long hi;

    memcpy(&hi, (unsigned char *)&v + 4, 4);
    return hi == 2147483647UL;
}
#endif
static long neg_sc(signed char c) { return (long)-c; }
static long com_sc(signed char c) { return (long)~c; }

static long add_l(int n) { return n + 40000L; }
static long sub_l(int n) { return n - 40000L; }
static long add_u1(unsigned n) { return n + 1L; }
static long add_m1(int n) { return n + 1L; }
static long add_uc(unsigned char n) { return n + 65536L; }
static long add_sc(signed char n) { return n + 1L; }
/* 8085 +test does not link the long-long helpers. Z80 does. */
#ifndef __8085
static long add_ll(int n) { return (long)(n + 40000LL); }
#endif

static long struct_fold(void)
{
    return (long)((struct S5 *)12 - (struct S5 *)2);
}

static void expect(const char *got, const char *want, const char *msg)
{
    Assert(strcmp(got, want) == 0, (char *)msg);
}

void test_conv(void)
{
    char buf[40];
    int *pa;
    char *pc;
    long *pl;

    /* B. Unsigned char zero-extends. Signed char sign-extends. */
    Assert((long)-vuc == -200L, "-(unsigned char)200");
    Assert((long)~vuc == -201L, "~(unsigned char)200");
    Assert((long)-vsc == 128L, "-(signed char)0x80");
    Assert((long)~vsc == 127L, "~(signed char)0x80");
    Assert(neg_uc(vuc) == -200L, "param -(unsigned char)");
    Assert(com_uc(vuc) == -201L, "param ~(unsigned char)");
    Assert(neg_sc(vsc) == 128L, "param -(signed char)");
    Assert(com_sc(vsc) == 127L, "param ~(signed char)");

    /* The low byte of the promoted operation. The condition and the
       shift still see the promoted int. */
    Assert(trunc_not(vuc) == 55, "byte ~(unsigned char)200");
    Assert(trunc_neg(vuc) == 56, "byte -(unsigned char)200");
    Assert(trunc_not_i(vuc) == 55, "implicit byte complement");
    Assert(trunc_neg_i(vuc) == 56, "implicit byte negation");
    Assert(trunc_neg_s(vsc) == 128, "byte -(signed char)0x80");
    Assert(take_uc(~vuc) == 55, "char parameter keeps the low byte");
    Assert((~vff && 1) == 1, "condition sees the promoted complement");
    Assert((unsigned char)(~vff >> 1) == 0x80, "shift sees the promoted complement");
    Assert((unsigned char)(~vuc + 1) == 56, "truncated sum keeps the promoted low byte");
    Assert(trunc_neg_sc(vsc) == (signed char)0x80, "signed return of -(signed char)0x80");
    Assert(init_neg(vuc) == 56, "char initializer keeps the low byte");
    Assert(tern_unop(vone, vuc) == 55, "ternary complement keeps the low byte");
    Assert(tern_unop(vzero, vuc) == 56, "ternary negation keeps the low byte");
    Assert((unsigned char)~vl == 55, "byte ~(long)200");
    Assert((unsigned char)-vl == 56, "byte -(long)200");
    Assert(tern_neg_div(vone, vuc, vd) == -100, "ternary negation then divide");
    Assert(tern_neg_div(vzero, vuc, vd) == 0, "false ternary arm then divide");
    Assert(tern_neg_div_uc(vone, vuc, vd) == 156, "char ternary negation then divide");
    Assert(tern_com_div_arg(vone, vuc, vd) == 156, "char argument of ternary complement then divide");
    Assert(tern_com_div_arg(vzero, vuc, vd) == 0, "false arm of that char argument");
    Assert(tern_com_shift(vone, vff) == 128, "ternary complement then shift");
    Assert(tern_com_shift(vzero, vff) == 0, "false arm of that shift");
    subarr[55] = 11;
    subarr[311] = 22;
    Assert(sub_com(vuc) == 11, "subscript of a promoted complement");
    Assert(tern_shift_same(vone, vff) == 128, "ternary complement of the same char then shift");
    Assert(tern_shift_same(vzero, vff) == 127, "false arm of that same-char shift");
    Assert(tern_both_shl(vone, vuc) == 400, "both char arms shift left as int");
    Assert(tern_sc_shr(vone, vsc) == -64, "signed char ternary then arithmetic shift");
    Assert(tern_sc_shl(vone, vsc) == -256, "signed char ternary then left shift");
    Assert(tern_ul_shr(vzero, 1UL, -1L) == 2147483647UL, "unsigned long ternary shift");
    Assert(tern_ul_shr(vone, 1UL, -1L) == 0UL, "true unsigned long arm then shift");
    Assert(tern_ui_si(vzero, vu, vm1) == 32767, "unsigned int ternary shift of -1");
    Assert(tern_ui_si(vone, vu, vm1) == 32767, "unsigned int arm of that shift");
    Assert(tern_add_shr(vone, vuc, vuc) == 200, "ternary of a char sum then shift");
    subarr[0] = 33;
    subarr[511] = 55;
    Assert(tern_sub(vone, vff) == 33, "subscript of a ternary complement");
    Assert(tern_sub(vzero, vff) == 55, "subscript of the char arm");
    Assert(add_shr(vuc, vuc) == 200, "char sum then shift");
    Assert(uc_plus_shr(vone, vm1 - 2) == -1, "unsigned char plus a negative int");
    Assert(uc_lt_neg(vuc, vm1) == 0, "unsigned char 200 < -1");
    Assert(shr_u_count(vm1, vone) == -1, "signed shift by an unsigned count");
    Assert(sc_shr_u(vsc, vone) == -64, "signed char shift by an unsigned count");
    Assert(sl_shr_u(-1L, vone) == -1L, "signed long shift by an unsigned count");
    Assert(lt_long_u(vone) == 1, "signed long less than an unsigned int");
    Assert(lt_long_u(vu) == 1, "signed long less than unsigned 65535");
    {
        volatile unsigned long n = 1;
        Assert(shr_wide_count(vm1, n) == 4294967295UL, "signed shift by a wider unsigned count");
    }
    Assert(cmp_arm(vone, vone, vd) == 1, "unsigned compare in a ternary arm");
    Assert(cmp_arm(vzero, vone, vd) == 7, "false arm beside an unsigned compare");
    Assert(cmp_both(vone, vone, vd, (unsigned)vd, (unsigned)vone) == 1, "true unsigned compare arm");
    Assert(cmp_both(vzero, (unsigned)vd, (unsigned)vone, vone, vd) == 1, "false unsigned compare arm");
#ifndef __8085
    Assert(ull_hi_logical(vzero, 1ULL, -1LL), "unsigned long long ternary shift");
    Assert(mix_ll_logical(-1LL, 0ULL), "signed long long plus unsigned long long");
    Assert(shr_c_ull(vm1) == -1, "signed shift by a constant long long count");
    Assert(shr_c_ull(vd) == 1, "positive shift by a constant long long count");
    Assert(shr_c0_ull(vm1) == -1, "shift by a constant zero long long count");
    Assert(shl_c_ull(vd) == 4, "left shift by a constant long long count");
    Assert(shr_c_ll(-2L) == -1L, "signed long shift by a constant long long count");
    Assert(shr_ull_rt(vd, 1ULL) == 1, "signed shift by a runtime long long count");
#endif

    /* C. Struct pointer difference. The element size is 5. */
    Assert(struct_fold() == 2L, "folded struct pointer difference");
    spa = (struct S5 *)20;
    spb = (struct S5 *)5;
    Assert((long)(spa - spb) == 3L, "runtime struct pointer difference");
    Assert((long)(spb - spa) == -3L, "negative struct pointer difference");

    /* D. Far pointer equality is 24 bits. A load clears D. */
    Assert((char *__far)0x01020304L == (char *__far)0x01020304L, "far equal");
    Assert((char *__far)0x01020304L != (char *__far)0x01020305L, "far unequal");
    Assert((char *__far)0x01020304L == (char *__far)0x00020304L, "far top byte is not compared");
    Assert((int *)100 == (int *)100, "near equal");
    Assert((char *__far)0x12345L + 1 == (char *__far)0x12346L, "far add");
    Assert((char *__far)0x81ff6L + 3 == (char *__far)0x81ff9L, "far add keeps the high byte");
    vfp = (char *__far)0x01020304L;
    Assert(vfp == (char *__far)0x01020304L, "runtime far equal");
    Assert((char *__far)0x01020304L == vfp, "runtime far equal, constant on the left");
    Assert(vfp != (char *__far)0x01020305L, "runtime far unequal");
    Assert(vfp == (char *__far)0x00020304L, "runtime far ignores the top byte");

    /* E. The element count is signed. */
    ip = iarr;
    iq = iarr + 5;
    Assert((int)(ip - iq) == -5, "p - (p + 5)");
    Assert((int)(iq - ip) == 5, "(p + 5) - p");
    pa = iarr;
    Assert((int)(pa - (pa + 5)) == -5, "symbol pointer difference");
    Assert((int)((pa + 5) - pa) == 5, "symbol pointer difference positive");
    pc = carr;
    Assert((int)(pc - (pc + 6)) == -6, "char pointer difference");
    pl = larr;
    Assert((int)(pl - (pl + 2)) == -2, "long pointer difference");

    /* F. Widen before the long constant. A 16-bit add sign-extends. */
    Assert(add_l(vi) == 40001L, "vi + 40000L");
    Assert(40000L + vi == 40001L, "40000L + vi");
    Assert(sub_l(vi) == -39999L, "vi - 40000L");
    Assert(40000L - vi == 39999L, "40000L - vi");
    Assert(add_u1(vu) == 65536L, "65535u + 1L");
    Assert(add_m1(vm1) == 0L, "-1 + 1L");
    Assert((long)((int)-1 + 40000UL) == 39999L, "(int)-1 + 40000UL");
    Assert((long)(32767 + 3L) == 32770L, "32767 + 3L");
    Assert(vi + 40000 == 40001L, "unsuffixed 40000 is long");
    Assert(vi + 100 == 101L, "vi + 100 stays in range");
    Assert((iarr + 5) - iarr == 5, "positive pointer difference stays a pointer difference");
    Assert(add_uc(vuc) == 65736L, "unsigned char + 65536L");
    Assert(add_sc((signed char)200) == -55L, "signed char + 1L");
#ifndef __8085
    Assert(add_ll(vi) == 40001L, "(long)(vi + 40000LL)");
#endif

    sprintf(buf, "%ld", vi + 40000L);
    expect(buf, "40001", "%ld of vi + 40000L");
}

int suite_conv(void)
{
    suite_setup("Runtime conversion");
    suite_add_test(test_conv);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_conv();
    exit(res);
}
