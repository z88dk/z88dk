/* [ds-fp-store] A word stored straight to an (ix+d) slot and never read back
 * is dropped; dropped spills have no slot, so the store must not be emitted
 * at all (it addressed below the frame). [dead-sp-addr] An `ld hl,N; add
 * hl,sp` for a load later folded to (ix+d) is removed. scratch() and
 * sum4() are those shapes, from localbench. */
#include "test.h"

static void bump(int *p, int k) { *p = (*p + k) & 0x3fff; }

static unsigned int scratch(unsigned int seed)
{
    int loc[16];
    unsigned int acc = 0;
    int i;
    for (i = 0; i < 16; i++)
        loc[i] = (int)((seed + (unsigned int)i * 37u) & 0x3fffu);
    for (i = 0; i < 16; i++) {
        int k = (int)((seed >> (i & 7)) & 15u);
        acc = (unsigned int)(acc + (unsigned int)loc[k]);
        loc[k] = (loc[k] + i) & 0x3fff;
    }
    return acc & 0xffffu;
}

static unsigned int sum4(unsigned int seed)
{
    int t[4];
    int v = (int)(seed & 0x3fffu);
    int i;
    for (i = 0; i < 4; i++)
        t[i] = (int)((seed >> i) & 255u);
    for (i = 0; i < 8; i++) {
        bump(&v, t[i & 3]);
        bump(&t[i & 3], v & 7);
    }
    return (unsigned int)((v + t[0] + t[1] + t[2] + t[3]) & 0xffff);
}

static unsigned int ref_scratch(unsigned int seed)
{
    static int loc[16];
    unsigned int acc = 0;
    int i;
    for (i = 0; i < 16; i++) loc[i] = (int)((seed + (unsigned int)i * 37u) & 0x3fffu);
    for (i = 0; i < 16; i++) {
        int k = (int)((seed >> (i & 7)) & 15u);
        acc += (unsigned int)loc[k];
        loc[k] = (loc[k] + i) & 0x3fff;
    }
    return acc;
}

static void test_dsfp(void)
{
    unsigned int s;
    for (s = 1; s < 60000u; s += 7919u)
        assertEqual(scratch(s), ref_scratch(s));
    assertEqual(sum4(0), 0);              /* host-verified */
    assertEqual(sum4(0x51A9u), 6179);
    assertEqual(sum4(0xffffu), 3107);
}

int main(int argc, char *argv[])
{
    suite_setup("dsfp");
    suite_add_test(test_dsfp);
    return suite_run();
}
