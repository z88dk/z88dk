

#include "string_tests.h"

static unsigned char dst[260];
static unsigned char src[260];


/* Low byte of n is zero. The stop character is still honoured. */
void memccpy_multiple_of_256()
{
    unsigned int i;
    unsigned char *p;

    for (i = 0; i < 260; i++) {
        src[i] = 'A';
        dst[i] = 'Z';
    }
    src[3] = 'X';

    p = memccpy(dst, src, 'X', 256);
    Assert(p == dst + 4, "Should stop after X");
    Assert(dst[0] == 'A', "Should copy the lead bytes");
    Assert(dst[3] == 'X', "Should copy the stop character");
    Assert(dst[4] == 'Z', "Copied past X");
}


/* Same entry, with n == 0: copy nothing and return NULL. */
void memccpy_size_zero()
{
    dst[0] = 'Z';
    src[0] = 'X';

    Assert(memccpy(dst, src, 'X', 0) == 0, "Should be NULL");
    Assert(dst[0] == 'Z', "Wrote when n is zero");
}


int test_memccpy()
{
    suite_setup("Memccpy Tests");

    suite_add_test(memccpy_multiple_of_256);
    suite_add_test(memccpy_size_zero);

    return suite_run();
}
