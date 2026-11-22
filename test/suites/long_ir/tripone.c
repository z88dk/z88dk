/* A loop with a constant trip count of 1 runs its body once. The index is
 * left at the bound afterwards, and a continue still reaches the loop exit.
 */
#include "test.h"

int gc;

static void bump(void) { ++gc; }

static int once_call(void)
{
    unsigned char i;
    gc = 0;
    for (i = 0; i < 1; ++i)
        bump();
    return gc;
}

static int once_index(void)
{
    unsigned char i;
    gc = 5;
    for (i = 0; i < 1; ++i)
        gc += 3;
    return gc * 10 + i;
}

static int once_continue(int x)
{
    unsigned char i;
    gc = 0;
    for (i = 0; i < 1; ++i) {
        if (x)
            continue;
        gc = 7;
    }
    return gc + i;
}

static int once_decl(void)
{
    int n = 0;
    for (int j = 0; j < 1; ++j)
        n += 4;
    return n;
}

static int once_offset(void)
{
    int i, n = 0;
    for (i = 9; i < 10; ++i)
        n += 2;
    return n * 100 + i;
}

static void check(void)
{
    assertEqual(once_call(), 1);
    assertEqual(once_index(), 81);
    assertEqual(once_continue(0), 8);
    assertEqual(once_continue(1), 1);
    assertEqual(once_decl(), 4);
    assertEqual(once_offset(), 210);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant trip count of 1");
    suite_add_test(check);
    return suite_run();
}
