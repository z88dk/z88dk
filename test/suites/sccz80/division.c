#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#ifndef __8080
  #ifndef __GBZ80
/* Runtime so the constant folder cannot answer. 2^32 does not fit in the
   16-bit remainder shortcut. 2LL minus an int does not fit in 16 bits. */
static long long ll_mod;
static unsigned long long ull_mod;
static int ll_sub_i;
static unsigned ll_sub_u;
static long ll_sub_l;

void test_llong_narrow(void)
{
    ll_mod = 4294967296LL;
    Assert(ll_mod % 10 == 6, "2^32 % 10");
    Assert(ll_mod % 3 == 1, "2^32 % 3");
    Assert(ll_mod % 100000LL == 67296LL, "2^32 % 100000");
    ll_mod = -5;
    Assert(ll_mod % 3 == -2, "-5LL % 3");
    Assert(ll_mod % 2 == -1, "-5LL % 2");
    ull_mod = 4294967296ULL;
    Assert(ull_mod % 10ULL == 6, "unsigned 2^32 % 10");

    ll_sub_i = 32767;
    ll_sub_i = -ll_sub_i - 1;
    Assert(2LL - ll_sub_i == 32770LL, "2LL - INT_MIN");
    ll_sub_i = 5;
    Assert(2LL - ll_sub_i == -3LL, "2LL - 5");
    ll_sub_i = 32767;
    Assert(2LL + ll_sub_i == 32769LL, "2LL + INT_MAX");
    ll_sub_u = 40000;
    Assert(2LL - ll_sub_u == -39998LL, "2LL - 40000u");
    ll_sub_l = -2147483647L - 1;
    Assert(2LL - ll_sub_l == 2147483650LL, "2LL - LONG_MIN");
}

void test_ullong_division()
{
     uint64_t val = 0x80000000LL;
     uint64_t res;
     Assert( val / 2           == 0x40000000LL, "val / 2");
     Assert( val / 4           == 0x20000000LL, "val / 4");
     Assert( val / 8           == 0x10000000LL, "val / 8");
     Assert( val / 16          == 0x08000000LL, "val / 16");
     Assert( val / 32          == 0x04000000, "val / 32");
     Assert( val / 64          == 0x02000000, "val / 64");
     Assert( val / 128         == 0x01000000, "val / 128");
     Assert( val / 256         == 0x00800000, "val / 256");
     Assert( val / 512         == 0x00400000, "val / 512");
     Assert( 0x80000000UL / 512 == 0x400000, "0x80000000 / 512");
}
  #endif
#endif

void test_ulong_division()
{
     uint32_t val = 0x80000000;
     uint32_t res;
     Assert( val / 2           == 0x40000000, "val / 2");
     Assert( val / 4           == 0x20000000, "val / 4");
     Assert( val / 8           == 0x10000000, "val / 8");
     Assert( val / 16          == 0x08000000, "val / 16");
     Assert( val / 32          == 0x04000000, "val / 32");
     Assert( val / 64          == 0x02000000, "val / 64");
     Assert( val / 128         == 0x01000000, "val / 128");
     Assert( val / 256         == 0x00800000, "val / 256");
     Assert( val / 512         == 0x00400000, "val / 512");
     Assert( 0x80000000UL / 512 == 0x00400000, "0x80000000 / 512");
}

void test_ulong_mod()
{
     unsigned long val = 162240UL;

     Assert( val % 7   == 1,  "162240UL % 7");
     Assert( val % 10  == 0,  "162240UL % 10");
     Assert( val % 100 == 40, "162240UL % 100");
}

void test_long_division()
{
     int32_t val = -256;
     Assert( val / 2  == -128, "-256 / 2");
     Assert( val / -4  ==  64, "-256 / -4");
     Assert( val / 8  ==  -32, "-256 / 8");
     Assert( val / -16  == 16, "-256 / -16");
     Assert( -val / 32  ==  8, " 256 / 32");
     Assert( -val / -64  == -4, " 256 / -64");
     Assert( val / 128  == -2, "-256 / 128");
     Assert( val / -256  == 1, "-256 / -256");
     Assert( val / 512  == 0, " -256 / 512");
     Assert( 0x80000000 / 512 == 0x00400000, "0x80000000 / 512");
}

void test_long_mod()
{
     int32_t val = -1;
     Assert( val % 2           == -1, "val % 2");   /* C99: remainder takes the dividend's sign */
     Assert( val % 4           == -1, "val % 4");
}

/* char operands must promote to int (value-preserving: signed char
   sign-extends) before the 16-bit divide helper. A prior 80cc bug widened
   signed-char operands with `ld h,0` (zero-extend), so -100/7 computed as
   156/7 == 22. Globals keep the operands out of the constant folder so the
   l_div / l_div_u helper path is exercised. */
signed char   schar_a, schar_b;
unsigned char uchar_a, uchar_b;

void test_char_division()
{
    schar_a = -100; schar_b = 7;
    Assert( schar_a / schar_b == -14, "schar -100 / 7");
    Assert( schar_a % schar_b == -2,  "schar -100 % 7");
    schar_b = -9;
    Assert( schar_a / schar_b == 11,  "schar -100 / -9");
    Assert( schar_a % schar_b == -1,  "schar -100 % -9");

    uchar_a = 200; uchar_b = 7;
    Assert( uchar_a / uchar_b == 28,  "uchar 200 / 7");
    Assert( uchar_a % uchar_b == 4,   "uchar 200 % 7");
}

void test_signed_division()
{
    int16_t val = -64;

    Assert( val / 2  == -32, "-64 / 2");
    Assert( val / -4  ==  16, "-64 / -4");
    Assert( val / 8  ==  -8, "-64 / 8");
    Assert( val / -16  ==  4, "-64 / -16");
    Assert( -val / -32  == -2, " 64 / -32");
    Assert( -val / 64  == 1, " 64 / 64");
    Assert( val / -128  == 0, "-64 / -128");
}

void test_signed_mod()
{
    int16_t val = -1;

    Assert( val % 2  == -1, "-1 % 2");      /* C99: remainder takes the dividend's sign */
    Assert( val % -4  == -1, "-1 % -4");
    Assert( val % 8  == -1, "-1 % 8");
    Assert( val % -16  == -1, "-1 % -16");
    Assert( -val % -32  == 1, " 1 % -32");
    Assert( -val % 64  == 1, " 1 % 64");
    Assert( -val % -128  == 1, " 1 % -128");
}


int suite_division()
{
    suite_setup("Division Tests");

#ifndef __8080
  #ifndef __GBZ80
    suite_add_test(test_llong_narrow);
    suite_add_test(test_ullong_division);
  #endif
#endif

    suite_add_test(test_char_division);
    suite_add_test(test_ulong_division);
    suite_add_test(test_ulong_mod);
    suite_add_test(test_long_division);
    suite_add_test(test_long_mod);
    suite_add_test(test_signed_division);
    suite_add_test(test_signed_mod);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_division();

    exit(res);
}
