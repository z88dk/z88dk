/* A byte copied through two global pointers, and an early return reached
 * through a conditional jump that does not fall into the return. */
#include "test.h"

static unsigned char *src, *dst;
static unsigned char version, admode, flag_a, flag_b;
static unsigned char buf[4];

static void copy_byte(void)
{
    dst[0] = src[0];
}

static void note(void)
{
    flag_b = 7;
}

static void tail(unsigned char opsize)
{
    if (opsize == 0)
        copy_byte();
    else if (opsize == 1) {
        dst[0] = src[0];
        dst[1] = src[1];
    }
    if (version < 2 || admode != 1) {
        flag_a = 0;
        note();
    }
}

void test_smallopts(void)
{
    buf[0] = 0x5a; buf[1] = 0xa5; buf[2] = 0; buf[3] = 0;
    src = &buf[0]; dst = &buf[2];
    version = 1; admode = 1; flag_a = 9; flag_b = 0;
    tail(0);
    assertEqual(buf[2], 0x5a);
    assertEqual(flag_a, 0);
    assertEqual(flag_b, 7);
    version = 3; admode = 1; flag_a = 9; flag_b = 0;
    tail(1);
    assertEqual(buf[3], 0xa5);
    assertEqual(flag_a, 9);
    assertEqual(flag_b, 0);
    admode = 2;
    tail(5);
    assertEqual(flag_a, 0);
    assertEqual(flag_b, 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("small opts");
    suite_add_test(test_smallopts);
    return suite_run();
}
