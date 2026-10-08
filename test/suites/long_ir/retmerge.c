/* Constant byte returns that share a tail. Tail merging runs first and keeps
 * `ld l,a` in the shared tail, so the narrowing of `ld a,N; ld l,a` must leave
 * a site whose A is read by that tail alone. Every path is checked.
 */
#include "test.h"

volatile int sink;

unsigned char pick(unsigned char k)
{
    sink = k;
    if (k == 0) return 10;
    if (k == 1) return 48;
    if (k == 2) return 200;
    if (k == 3) return (unsigned char)(sink + 7);
    return 255;
}

static int run(void)
{
    int bad = 0;
    if (pick(0) != 10) bad++;
    if (pick(1) != 48) bad++;
    if (pick(2) != 200) bad++;
    if (pick(3) != 10) bad++;
    if (pick(4) != 255) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant byte returns sharing a merged tail");
    suite_add_test(check);
    return suite_run();
}
