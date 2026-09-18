/* [shr-tbac] A masked `(x >> n) & M` inside a loop gives up the top-byte
 * `add hl,hl x (8-n)` route for the A-chain: +4 bytes to buy -19 T per
 * iteration at n==3, and a win on both axes at n==2.
 *
 * `loop3`/`loop2` are the shapes that must change; `cold3` is the same
 * expression OUTSIDE a loop and must NOT change, which is the whole point of
 * the loop gate. `deep4` is n==4, where the two routes cross and the top-byte
 * form wins on both axes, so it must stay put too. The keep targets prove the
 * same source runs with the rung disabled.
 */
#include "test.h"

unsigned int loop3(unsigned int seed, unsigned int n)
{
    unsigned int acc = 0, i;
    for (i = 0; i < n; i++) {
        acc = (unsigned int)(acc + ((seed >> 3) & 63u));
        seed = (unsigned int)(seed * 3u + 1u);
    }
    return acc;
}

unsigned int loop2(unsigned int seed, unsigned int n)
{
    unsigned int acc = 0, i;
    for (i = 0; i < n; i++) {
        acc = (unsigned int)(acc + ((seed >> 2) & 31u));
        seed = (unsigned int)(seed * 5u + 7u);
    }
    return acc;
}

unsigned char cold3(unsigned int x) { return (unsigned char)((x >> 3) & 63u); }
unsigned char deep4(unsigned int x) { return (unsigned char)((x >> 4) & 15u); }

static void test_shrtbac(void)
{
    assertEqual(cold3(0xBEEFu), 0x1Du);
    assertEqual(cold3(0u), 0u);
    assertEqual(deep4(0xBEEFu), 0x0Eu);
    assertEqual(deep4(0xFFFFu), 0x0Fu);
    assertEqual(loop3(0xBEEFu, 0), 0);
    assertEqual(loop3(1u, 1), 0);
    assertEqual(loop2(0xBEEFu, 0), 0);
    assertEqual(loop2(1u, 1), 0);
    assertEqual(loop3(0xBEEFu, 8), 206);
    assertEqual(loop2(0xBEEFu, 8), 96);
    assertEqual(loop3(0xBEEFu, 64), 2032);
    assertEqual(loop2(0xBEEFu, 64), 1056);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("masked shift gives up the top-byte route under loop pressure");
    suite_add_test(test_shrtbac);
    return suite_run();
}
