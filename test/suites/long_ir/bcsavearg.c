/* A constant fastcall argument is its own BC tenant and dies at the call, so
 * BC is not saved around it; the loop counter and the key index that live
 * across the same calls must still be saved.
 */
#include "test.h"

int total;
unsigned char keys[8];

unsigned char chg(signed char d) __z88dk_fastcall
{
    total += d;
    return total != 0;
}

unsigned char key(unsigned char i)
{
    return keys[i];
}

int run(unsigned char n)
{
    unsigned char i;
    int acc = 0;

    for (i = 0; i < n; i++) {
        switch (key(i)) {
        case 1: if (!chg(-1)) continue; break;
        case 2: if (!chg(1)) continue; break;
        default: continue;
        }
        acc += 10;
    }
    return acc * 100 + i;
}

static void check(void)
{
    keys[0] = 1; keys[1] = 2; keys[2] = 1; keys[3] = 3; keys[4] = 2;
    total = 0;
    assertEqual(run(5), 2005);
    assertEqual(total, 0);
    total = 1;
    assertEqual(run(5), 2005);
    assertEqual(total, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant fastcall argument and live BC");
    suite_add_test(check);
    return suite_run();
}
