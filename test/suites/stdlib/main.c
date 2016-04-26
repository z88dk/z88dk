

#include "stdlib_tests.h"

int main(int argc, char *argv[])
{
    int  res = 0;

    res += test_abs();
    res += test_isqrt();
    res += test_isqrt2();
    res += test_strtol();

    return res;
}
