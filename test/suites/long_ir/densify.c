/* Word stores from DE to a frame slot, a store through a pointer with the
 * value parked on the stack, and signed word division by 2^k (sign mask
 * widened then masked).
 */
#include "test.h"

int freq[8];
int son[8];

static int g(int v) { return v; }

static int init_slot(int n)
{
    char line[200];
    int p = 100;
    int k = 0;
    line[0] = 0;
    do {
        if (g(k) == 3) p -= 5;
        k++;
    } while (p > 0 && k < n);
    return p + line[0];
}

static void copy_half(int i, int j)
{
    freq[j] = (freq[i] + 1) / 2;
    son[j] = son[i];
}

static int d2(int x) { return x / 2; }
static int d4(int x) { return x / 4; }
static int d8(int x) { return x / 8; }

static void check(void)
{
    assertEqual(init_slot(2), 100);
    assertEqual(init_slot(5), 95);
    freq[1] = 9; son[1] = 0x1234;
    freq[2] = -9; son[2] = -4;
    copy_half(1, 5);
    assertEqual(freq[5], 5);
    assertEqual(son[5], 0x1234);
    copy_half(2, 6);
    assertEqual(freq[6], -4);
    assertEqual(son[6], -4);
    assertEqual(d2(7), 3);
    assertEqual(d2(-7), -3);
    assertEqual(d2(-8), -4);
    assertEqual(d2(0), 0);
    assertEqual(d2(-32768), -16384);
    assertEqual(d4(-9), -2);
    assertEqual(d4(9), 2);
    assertEqual(d8(-17), -2);
    assertEqual(d8(31), 3);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("fp DE slot store, parked store value, signed word div");
    suite_add_test(check);
    return suite_run();
}
