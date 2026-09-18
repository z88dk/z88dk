/* [shr-dead-l] The A-through-CB constant word right shift (ADR 0090) is reached
 * with the word load's `ld l,a` in front of it, and `dead-regcopy` removes the
 * chain's own `ld a,l` because A already holds the low byte. That leaves the
 * earlier store with no reader, and this suite proves dropping it is silent.
 *
 * Every count the chain accepts (2..7) is covered, plus the two counts just
 * outside it: 1 stays on `srl h; rr l` and 9 takes the byte-move path, so a
 * change to the chain's bounds shows up here as a wrong value rather than only
 * as a size difference. `chain_then_use` reads the shifted value twice, so a
 * store dropped in error cannot hide behind an unread L.
 */
#include "test.h"

unsigned int shr1(unsigned int x) { return x >> 1; }
unsigned int shr2(unsigned int x) { return x >> 2; }
unsigned int shr3(unsigned int x) { return x >> 3; }
unsigned int shr4(unsigned int x) { return x >> 4; }
unsigned int shr5(unsigned int x) { return x >> 5; }
unsigned int shr6(unsigned int x) { return x >> 6; }
unsigned int shr7(unsigned int x) { return x >> 7; }
unsigned int shr9(unsigned int x) { return x >> 9; }

unsigned int chain_then_use(unsigned int x)
{
    unsigned int v = x >> 3;
    return (unsigned int)(v + (v << 1));
}

static void test_shrdeadl(void)
{
    assertEqual(shr1(0xBEEFu), 0x5F77u);
    assertEqual(shr2(0xBEEFu), 0x2FBBu);
    assertEqual(shr3(0xBEEFu), 0x17DDu);
    assertEqual(shr4(0xBEEFu), 0x0BEEu);
    assertEqual(shr5(0xBEEFu), 0x05F7u);
    assertEqual(shr6(0xBEEFu), 0x02FBu);
    assertEqual(shr7(0xBEEFu), 0x017Du);
    assertEqual(shr9(0xBEEFu), 0x005Fu);

    assertEqual(shr2(0xFFFFu), 0x3FFFu);
    assertEqual(shr3(0xFFFFu), 0x1FFFu);
    assertEqual(shr7(0xFFFFu), 0x01FFu);
    assertEqual(shr4(0u), 0u);
    assertEqual(shr5(1u), 0u);

    assertEqual(chain_then_use(0xBEEFu), 0x4797u);
    assertEqual(chain_then_use(0u), 0u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("dead l store before an a-through-cb shift chain");
    suite_add_test(test_shrdeadl);
    return suite_run();
}
