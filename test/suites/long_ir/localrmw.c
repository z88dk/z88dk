/* GBZ80 word read-modify-write with a frame-resident local array.
 *
 * The loop shape is shared with localbench/scratch: the compiler can retain
 * the loop counter in BC while the element address and updated word are
 * temporarily parked on the stack. The expected value is fixed so the test
 * catches a bad stack offset or an unbalanced temporary push/pop.
 */
#include "test.h"

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

/* Synthetic near-matches exercise the liveness gates directly. These
 * functions are emitted but never called: the literal stack offsets describe
 * the localbench frame. The first is dead at the tail and should rewrite; the
 * A-live and F-live variants must retain the source sequence. */
#if defined(__GBZ80)
#define GBZ80_RMW_RAW \
    "ex\tde,hl\n" \
    "\tld\thl,34\n" \
    "\tadd\thl,sp\n" \
    "\tld\t(hl),e\n" \
    "\tinc\thl\n" \
    "\tld\t(hl),d\n" \
    "\tld\thl,de\n" \
    "\tld\ta,(hl+)\n" \
    "\tld\th,(hl)\n" \
    "\tld\tl,a\n" \
    "\tex\tde,hl\n" \
    "\tld\thl,36\n" \
    "\tadd\thl,sp\n" \
    "\tld\t(hl),e\n" \
    "\tinc\thl\n" \
    "\tld\t(hl),d\n" \
    "\tld\thl,de\n" \
    "\tex\tde,hl\n" \
    "\tld\thl,32\n" \
    "\tadd\thl,sp\n" \
    "\tld\ta,(hl+)\n" \
    "\tld\th,(hl)\n" \
    "\tld\tl,a\n" \
    "\tadd\thl,de\n" \
    "\tex\tde,hl\n" \
    "\tld\thl,32\n" \
    "\tadd\thl,sp\n" \
    "\tld\t(hl),e\n" \
    "\tinc\thl\n" \
    "\tld\t(hl),d\n" \
    "\tld\thl,36\n" \
    "\tadd\thl,sp\n" \
    "\tld\ta,(hl+)\n" \
    "\tld\th,(hl)\n" \
    "\tld\tl,a\n" \
    "\tadd\thl,bc\n" \
    "\tld\ta,h\n" \
    "\tand\t63\n" \
    "\tld\th,a\n" \
    "\tex\tde,hl\n" \
    "\tld\thl,34\n" \
    "\tadd\thl,sp\n" \
    "\tld\ta,(hl+)\n" \
    "\tld\th,(hl)\n" \
    "\tld\tl,a\n" \
    "\tld\t(hl),e\n" \
    "\tinc\thl\n" \
    "\tld\t(hl),d\n"

void gbz80_rmw_guard_dead(void) { __asm__(GBZ80_RMW_RAW "xor a\n"); }
void gbz80_rmw_guard_a_live(void) { __asm__(GBZ80_RMW_RAW "ld a,a\nxor a\n"); }
void gbz80_rmw_guard_f_live(void)
{
    __asm__(GBZ80_RMW_RAW "jp z,L_rmw_flags_live\nL_rmw_flags_live:\nxor a\n");
}
#endif

static void test_local_rmw(void)
{
    assertEqual(scratch(0x51a9u), 11286u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Frame-array word RMW");
    suite_add_test(test_local_rmw);
    return suite_run();
}
