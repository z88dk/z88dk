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

static unsigned int f1(unsigned int a, unsigned int b) { return (unsigned int)(a * 3u + b); }
static unsigned int f2(unsigned int a) { return (unsigned int)(a ^ 0x55u); }
static unsigned int f3(unsigned int a, unsigned int b, unsigned int c) { return (unsigned int)(a + b + c); }

/* sum carried through three call results per iteration, then copied back */
static unsigned int chain_sum(unsigned int n)
{
    unsigned int total = 0, i, k;
    for (k = 0; k < 3; k++) {
        for (i = 0; i < n; i++) {
            total += f1(i, k);
            total += f2(i);
            total += f3(i, k, total & 7u);
            total &= 0xffffu;
        }
    }
    return total;
}

static void check(void)
{
    assertEqual(chain_sum(0), 0u);
    assertEqual(chain_sum(1), 266u);
    assertEqual(chain_sum(4), 1167u);
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
