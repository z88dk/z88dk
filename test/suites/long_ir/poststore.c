/* Two stores in a row through a post-stepping pointer (`*d++ = c; *d++ = c;`)
 * write two different bytes. The second is not an overwrite of the first, so
 * neither may be dropped as a dead store.
 */
#include "test.h"

static unsigned char line[8];
static unsigned char cols[4] = { 1, 2, 3, 4 };

static void expand(const unsigned char *colours)
{
    unsigned char *d = line, x, c;

    for (x = 0; x < 4; ++x) {
        c = colours[x];
        *d++ = c;
        *d++ = c;
    }
}

static void down(unsigned char v)
{
    unsigned char *d = line + 7;

    *d-- = v;
    *d-- = v + 1;
    *d-- = v + 2;
}

static void plain_then_step(unsigned char v)
{
    unsigned char *d = line;

    *d = v;
    *d++ = v + 1;           /* overwrites line[0], then steps */
    *d = v + 2;             /* line[1] */
}

static void overwrite(unsigned char v)
{
    unsigned char *d = line + 4;

    *d = v;
    *d = v + 9;             /* a real overwrite: the first store is dead */
}

static void check(void)
{
    int i;

    expand(cols);
    for (i = 0; i < 8; ++i)
        assertEqual(line[i], cols[i / 2]);

    for (i = 0; i < 8; ++i) line[i] = 0;
    down(10);
    assertEqual(line[7], 10);
    assertEqual(line[6], 11);
    assertEqual(line[5], 12);
    assertEqual(line[4], 0);

    for (i = 0; i < 8; ++i) line[i] = 0;
    plain_then_step(20);
    assertEqual(line[0], 21);
    assertEqual(line[1], 22);

    overwrite(30);
    assertEqual(line[4], 39);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("consecutive post-stepping stores are all kept");
    suite_add_test(check);
    return suite_run();
}
