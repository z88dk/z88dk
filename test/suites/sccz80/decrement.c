#include "test.h"
#include <stdio.h>
#include <stdlib.h>

// l_i64_dec must propagate the borrow into the more significant bytes
// whenever a byte wraps from 0x00 to 0xff
void test_predec64(void)
{
     long long v;

     v = 1;
     Assert( --v == 0, "1 - 1");
     v = 0x100;
     Assert( --v == 0xff, "0x100 - 1");
     v = 0x10000;
     Assert( --v == 0xffff, "0x10000 - 1");
     v = 0x100000000LL;
     Assert( --v == 0xffffffffLL, "0x100000000 - 1");
     v = 0x100000000000000LL;
     Assert( --v == 0xffffffffffffffLL, "0x100000000000000 - 1");
     v = 0x1234567800000000LL;
     Assert( --v == 0x12345677ffffffffLL, "0x1234567800000000 - 1");
     v = 0;
     Assert( --v == -1, "0 - 1");
     v = 0x8000000000000000LL;
     Assert( --v == 0x7fffffffffffffffLL, "0x8000000000000000 - 1");
}

void test_postdec64(void)
{
     long long v;

     v = 0x100;
     Assert( v-- == 0x100, "0x100-- value");
     Assert( v == 0xff, "0x100-- result");
     v = 0x100000000LL;
     Assert( v-- == 0x100000000LL, "0x100000000-- value");
     Assert( v == 0xffffffffLL, "0x100000000-- result");
     v = 0;
     Assert( v-- == 0, "0-- value");
     Assert( v == -1, "0-- result");
}

void test_preinc64(void)
{
     long long v;

     v = 0xff;
     Assert( ++v == 0x100, "0xff + 1");
     v = 0xffffffffLL;
     Assert( ++v == 0x100000000LL, "0xffffffff + 1");
     v = -1;
     Assert( ++v == 0, "-1 + 1");
}

/* Constant +/ - must use the full 64-bit addend. A truncated test turns
   x - 1 into an increment and drops x + 4294967296 altogether. */
void test_addconst64(void)
{
     long long v;
     char c;
     int i;
     long l;

     v = 5;
     v -= 1;
     Assert( v == 4, "5LL -= 1");
     v = 5;
     v += -1;
     Assert( v == 4, "5LL += -1");
     v = 5;
     v += 1;
     Assert( v == 6, "5LL += 1");
     v = 5;
     v += 4294967296LL;
     Assert( v == 4294967301LL, "5LL += 4294967296");
     v = 5;
     v += 4294967297LL;
     Assert( v == 4294967302LL, "5LL += 4294967297");

     c = 5;
     i = 5;
     l = 5;
     c -= 1;
     i += -1;
     l += 1;
     Assert( c == 4 && i == 4 && l == 6, "narrow constant add");
}

int suite_decrement()
{
    suite_setup("Increment/Decrement Tests");
#ifndef __8080
  #ifndef __GBZ80
    suite_add_test(test_predec64);
    suite_add_test(test_postdec64);
    suite_add_test(test_preinc64);
    suite_add_test(test_addconst64);
  #endif
#endif

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_decrement();

    exit(res);
}
