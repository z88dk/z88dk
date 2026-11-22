/* [dead-slot-drop] A value whose frame slot the render never touched loses the
 * slot and the function is rendered again with the smaller frame. The other
 * slots move, so every read below goes through a recompacted offset; a value
 * that does reach its slot on the new render puts the slots back. */
#include "test.h"

#define NB 64
static unsigned int bins[NB];
static unsigned int res[12];

/* histbench's hist_pass: a byte temp of the index keeps an untouched slot. */
static unsigned int hist_pass(unsigned int seed, int n)
{
    int i;
    for (i = 0; i < n; i++) {
        seed = (unsigned int)(seed * 25173u + 13849u);
        bins[(seed >> 3) & (NB - 1)]++;
    }
    return seed;
}

static int fib(int n)
{
    if (n <= 2) return 1;
    return fib(n - 1) + fib(n - 2);
}

static unsigned int sink;
static void note(int a, unsigned int b) { sink += (unsigned int)a * 3u + b; }

/* fib.c's main: the loop counter is read both from a register and the slot. */
static unsigned int fib_loop(void)
{
    int loop;
    unsigned int s = 0;
    for (loop = 1; loop < 11; loop++) {
        res[loop] = fib(loop);
        note(loop, res[loop]);
        s += res[loop];
    }
    return s;
}

/* Several slotted values across calls: some keep a slot, some lose it. */
static int mix(int a, int b, int c)
{
    int x = a * 3, y = b + 7, z = c ^ 0x55;
    char t = (char)(a + b);
    note(x, (unsigned int)y);
    note(y, (unsigned int)z);
    t = (char)(t + z);
    note(z, (unsigned int)x);
    return x + y + z + t;
}

static void test_slotdrop(void)
{
    int i;
    unsigned int chk = 0;
    for (i = 0; i < NB; i++) bins[i] = 0;
    assertEqual(hist_pass(0x0777, 1000), 15663);
    for (i = 0; i < NB; i++) chk += bins[i] * (unsigned int)(i + 1);
    assertEqual(chk, 32360);
    sink = 0;
    assertEqual(fib_loop(), 143);
    assertEqual(sink, 308);
    sink = 0;
    assertEqual(mix(5, 9, 3), 217);
    assertEqual(sink, 468);
}

int main(int argc, char *argv[])
{
    suite_setup("slotdrop");
    suite_add_test(test_slotdrop);
    return suite_run();
}
