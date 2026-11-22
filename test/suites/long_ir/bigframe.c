/* A local array of exactly 32768 bytes: the frame size no longer fits a signed
 * 16-bit width, but z80 address arithmetic is modulo 64K so it is legal.
 * Both ends of the array and a scalar beside it are read back.
 */
#include "test.h"

static int touch(char *p, int i)
{
    p[i] = (char)(i + 1);
    return p[i];
}

static int run(void)
{
    char buf[32768];
    int k = 7;
    int s = touch(buf, 5) + touch(buf, 32767) + touch(buf, 0);
    return (s == 6 + 0 + 1) && k == 7 ? 0 : 1;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("32768-byte local array");
    suite_add_test(check);
    return suite_run();
}
