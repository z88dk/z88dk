/* [byte-ret] A constant byte return is `ld l,N` instead of `ld a,N` / `ld l,a`.
 *
 * ret16 is the bare return. ret0 must stay `xor a` (flags). both stores the
 * same constant and returns it. framed keeps a live frame between the pair
 * and ret. keep (gate off) returns the same numbers. signed -1 and the int
 * return stay `ld hl`.
 */
#include "test.h"

static unsigned char ret16(void)
{
    return 16;
}

static unsigned char ret0(void)
{
    return 0;
}

static unsigned char both(unsigned char *p)
{
    *p = 16;
    return 16;
}

static unsigned char framed(int x)
{
    volatile unsigned char buf[4];

    buf[0] = (unsigned char)x;
    buf[1] = buf[0];
    return 16;
}

static signed char retm1(void)
{
    return -1;
}

static int retint(void)
{
    return 16;
}

void test_byteret(void)
{
    unsigned char slot = 0;

    assertEqual(ret16(), 16);
    assertEqual(ret0(), 0);
    assertEqual(both(&slot), 16);
    assertEqual(slot, 16);
    assertEqual(framed(3), 16);
    assertEqual((unsigned char)retm1(), 255);
    assertEqual(retint(), 16);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant byte return loads L");
    suite_add_test(test_byteret);
    return suite_run();
}
