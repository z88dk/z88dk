/* [pair-bitop] [de-home-step] [dehome-dead-exit] Word NOT/AND/OR/XOR between
 * register-resident words, a counter stepped in DE, and a loop exit that leaves
 * the counter dead or live. Every result is checked against a value computed
 * independently. */
#include "test.h"

static unsigned int logic_loop(unsigned int m)
{
    unsigned int i = 0, j = 0;
    do { i++; j = ~i; j &= m; j |= i; j ^= m; } while (i <= 9999);
    return j;
}

/* the counter is read after the loop: it must hold its final value */
static unsigned int live_after(unsigned int m, unsigned int *out)
{
    unsigned int i = 0, j = 0;
    do { i++; j ^= (~i & m) | i; } while (i < 777);
    *out = i;
    return j;
}

/* a call in the body: the counter cannot stay in DE across it */
static unsigned int sink;
static void touch(unsigned int v) { sink += v; }
static unsigned int with_call(unsigned int m)
{
    unsigned int i = 0, j = 0;
    do { i++; j = ~i; j &= m; touch(j); j ^= i; } while (i < 300);
    return j + (sink & 0xff);
}

/* count down, and a second word value in the mix */
static unsigned int down(unsigned int m, unsigned int k)
{
    unsigned int i = 500, j = 0;
    do { i--; j = (j ^ i) & m; j |= k; j = ~j; } while (i != 0);
    return j;
}

/* the counter starts from a parameter (a MOV into the DE home) and is added
   into a stack-parked accumulator inside the loop */
static int sink2;
static int mov_init(int start, int n)
{
    int a = 7, s = 0, i;
    for (i = start; i < n; i++) { a += i; s += 2; }
    sink2 = a;
    return s + a;
}

static void test_pairbitop(void)
{
    unsigned int o;
    assertEqual(logic_loop(0x0f0f), 8208U);
    assertEqual(logic_loop(0xffff), 0U);
    assertEqual(live_after(0x00f0, &o), 241U);
    assertEqual(o, 777U);
    sink = 0;
    assertEqual(with_call(0x3c3c), 15856U);
    assertEqual(down(0xaaaa, 0x0101), 21588U);
}

int suite_pairbitop(void) { suite_setup("pair bitop"); suite_add_test(test_pairbitop); return suite_run(); }
int main(void) { return suite_pairbitop(); }
