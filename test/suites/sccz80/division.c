#include "test.h"
#include <stdio.h>
#include <stdlib.h>

#ifndef __8080__
  #ifndef __GBZ80__
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
     Assert( 0x80000000UL/ 512 == 0x400000, "0x80000000/ 512");
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
     Assert( 0x80000000UL/ 512 == 0x400000, "0x80000000/ 512");
}

void test_long_division()
{
     int32_t val = -1;
     Assert( val / 2           == 0, "val / 2");
     Assert( val / 4           == 0, "val / 4");
     Assert( val / 8           == 0, "val / 8");
     Assert( val / 16          == 0, "val / 16");
     Assert( val / 32          == 0, "val / 32");
     Assert( val / 64          == 0, "val / 64");
     Assert( val / 128         == 0, "val / 128");
     Assert( val / 256         == 0, "val / 256");
     Assert( val / 512         == 0, "val / 512");
     Assert( 0x80000000/ 512 == 0x00400000, "0x80000000/ 512");
}

void test_long_mod()
{
     int32_t val = -1;
     Assert( val % 2           == 1, "val % 2");
     Assert( val % 4           == 1, "val % 4");
}

void test_signed_division()
{
    int16_t val = -1;

    Assert( val / 2  == 0, "-1 / 2");
    Assert( val / 4  == 0, "-1 / 4");
    Assert( val / 8  == 0, "-1 / 8");
    Assert( val / 16  == 0, "-1 / 16");
    Assert( val / 32  == 0, "-1 / 32");
    Assert( val / 64  == 0, "-1 / 64");
    Assert( val / 128  == 0, "-1 / 128");
    Assert( val / 256  == 0, "-1 / 256");
}

void test_signed_mod()
{
    int16_t val = -1;

    Assert( val % 2  == 1, "-1 % 2");
    Assert( val % 4  == 1, "-1 % 4");
    Assert( val % 8  == 1, "-1 % 8");
    Assert( val % 16  == 1, "-1 % 16");
    Assert( val % 32  == 1, "-1 % 32");
    Assert( val % 64  == 1, "-1 % 64");
    Assert( val % 128  == 1, "-1 % 128");
    Assert( val % 256  == 1, "-1 % 256");
}


int suite_mult()
{
    suite_setup("Division Tests");

#ifndef __8080__
  #ifndef __GBZ80__
    suite_add_test(test_ullong_division);
  #endif
#endif

    suite_add_test(test_ulong_division);
    suite_add_test(test_long_division);
    suite_add_test(test_long_mod);
    suite_add_test(test_signed_division);
    suite_add_test(test_signed_mod);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_mult();

    exit(res);
}
