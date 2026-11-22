
#include "malloc_tests.h"

int main(int argc, char *argv[])
{
    int res = 0;

    res += test_malloc();
    res += test_malloc_fl();

    /* ticks reads this byte after the CP/M warm boot */
    *(unsigned char *)0x80 = (unsigned char)(res ? 1 : 0);
    return res;
}
