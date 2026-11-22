
#include "ixsave_tests.h"

int main(int argc, char *argv[])
{
    int res = 0;

    res += test_memop();
    res += test_rect();

    return res;
}
