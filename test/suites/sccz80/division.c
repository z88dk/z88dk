#include "test.h"
#include <stdio.h>
#include <stdlib.h>


void test_ulong_division()
{
     uint32_t val = 0x80000000;
     uint32_t res;
     Assert( val / 512         == 0x400000, "val / 512");
     Assert( 0x80000000UL/ 512 == 0x400000, "0x80000000/ 512");
}

void test_long_division()
{
     int32_t val = -1;
     Assert( val / 512         == 0, "val / 512");
     Assert( 0x80000000/ 512 == 0xffc00000, "0x80000000/ 512");
}

int suite_mult()
{
    suite_setup("Division Tests");

    suite_add_test(test_ulong_division);
    suite_add_test(test_long_division);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_mult();

    exit(res);
}
