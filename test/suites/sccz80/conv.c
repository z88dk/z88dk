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
