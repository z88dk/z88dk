/* A function declared inside a function body names the function and allocates
 * nothing; its name used as a value or with & is the function's address.
 */
#include "test.h"

int twice(int x) { return x * 2; }
int thrice(int x) { return x * 3; }

static int apply(int (*f)(int), int v) { return f(v); }

static int run(void)
{
    int twice(int);
    int thrice();
    int bad = 0;
    int (*fp)(int);

    if (twice(4) != 8) bad++;
    if (apply(twice, 5) != 10) bad++;
    if (apply(&twice, 6) != 12) bad++;
    fp = thrice;
    if (fp(3) != 9) bad++;
    fp = &thrice;
    if (apply(fp, 2) != 6) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("block-scope function declarations");
    suite_add_test(check);
    return suite_run();
}
