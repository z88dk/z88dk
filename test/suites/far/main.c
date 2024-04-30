 

#include "far_tests.h"

int main(int argc, char *argv[])
{
    int  res = 0;

    // Add some memory into the farheap
    sbrk_far(0x00010000, 0xffff);
    res += test_strncatf();
    res += test_strcmpf();
    res += test_strcasecmpf();
    res += test_strchrf();
    res += test_sprintf();

    return res;
}
