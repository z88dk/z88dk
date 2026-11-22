

#include "stdlib_tests.h"

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_abs();
#ifndef __8080
    res += test_isqrt();
    res += test_isqrt2();
#endif
    res += test_strtol();
    res += test_unbcd();
#ifndef __8080
  #ifndef __GBZ80
    res += test_qsort();
    res += test_bsearch();
    // test_qsort_newlib() lives in its own binary (test_newlib.bin) -- see main_newlib.c
 #endif
#endif

    return res;
}
