/* A loop-carried sum accumulated in an index register while the counter is
 * stepped in BC: the add leaves DE holding the old counter, and the step must
 * not leave that copy believed current for the loop compare.
 */
#include "test.h"

static unsigned int g_sink;

static void sink(unsigned int v) { g_sink = v; }

static unsigned int sum_to(unsigned int n)
{
    unsigned int acc = 0, i = 0;
    if (n == 0u) goto done;
loop:
    acc = (unsigned int)(acc + i);
    i++;
    if (i < n) goto loop;
done:
    acc = (unsigned int)(acc ^ 0x0fu);
    sink(acc);
    return acc;
}

static void check(void)
{
    assertEqual(sum_to(0), 15u);
    assertEqual(sum_to(1), 15u);
    assertEqual(sum_to(2), 14u);
    assertEqual(sum_to(5), 5u);
    assertEqual(g_sink, 5u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("index-register sum with stepped counter");
    suite_add_test(check);
    return suite_run();
}
