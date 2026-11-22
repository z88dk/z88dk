/* Byte-width narrowing of a LOAD (ldmem_narrowable).
 *
 * A load whose result is only ever read as a byte reads one byte: `ld a,(_sym)`
 * for a global, `ld a,(hl)` for an indirect. Every target is little-endian, so
 * the byte at the base address is the low byte -- which is what makes the
 * narrowing exact, and what these cases check by giving every word a NONZERO
 * high byte. A narrowing that read the wrong end, or that let a high byte
 * survive into the result, shows up as a wrong sum rather than a crash.
 *
 * The exclusion that has to be pinned is the post-stepped deref: `*p++` on a
 * word pointer steps by TWO, and the byte lowering steps by one. If a narrowed
 * width-2 walk kept the byte step it would advance half as far and read the
 * high byte of each element as the next element -- `walk` catches exactly that.
 *
 * `wide_use` holds the other side: the same global read at full width must
 * keep both bytes.
 *
 * (The volatile and port exclusions are not observable from C -- a volatile
 * read narrowed to a byte still yields the right value here. They are asserted
 * in ldmem_narrowable, not in this test.)
 */
#include "test.h"

static unsigned int wg  = 0x1234u;
static unsigned int wg2 = 0xff07u;
static unsigned int warr[4] = { 0x1102u, 0x2204u, 0x3306u, 0x4408u };
static volatile unsigned int vg = 0xaa55u;

/* Global word read, low byte only. */
static unsigned char g_lowbyte(void)     { return (unsigned char)wg; }

/* Two byte-narrowed global reads combined by byte arithmetic. */
static unsigned char g_mix(void)
{
    return (unsigned char)((unsigned char)wg ^ (unsigned char)wg2);
}

/* The same global at full width: both bytes must survive. */
static unsigned int wide_use(void)       { return wg; }

/* Indirect word deref, low byte only -- no step. */
static unsigned char p_lowbyte(unsigned int *p) { return (unsigned char)(*p); }

/* Post-stepped word deref reading only low bytes. The pointer must still
   advance two bytes per element: 0x02+0x04+0x06+0x08 = 0x14. Stepping by one
   would sum 0x02+0x11+0x04+0x22 instead. */
static unsigned int walk(unsigned int *p, int n)
{
    unsigned int acc = 0;
    while (n-- > 0)
        acc = (unsigned int)(acc + (unsigned char)(*p++));
    return acc;
}

/* Indirect load with a constant offset, low byte only. */
static unsigned char elem_lowbyte(unsigned int *p, int i)
{
    return (unsigned char)(p[i]);
}

/* A narrowed load feeding a byte compare, then a branch on it. */
static int gate(unsigned int *p)
{
    unsigned char b = (unsigned char)(*p);
    if (b == 0x04u) return 1;
    if (b < 0x04u)  return 2;
    return 3;
}

static unsigned char vol_lowbyte(void)   { return (unsigned char)vg; }

static void test_narrowld(void)
{
    assertEqual(g_lowbyte(), 0x34);
    assertEqual(g_mix(), 0x34 ^ 0x07);
    assertEqual(wide_use(), 0x1234u);

    assertEqual(p_lowbyte(&warr[0]), 0x02);
    assertEqual(p_lowbyte(&warr[3]), 0x08);

    assertEqual(walk(warr, 4), 0x14u);     /* stepping by 2, low bytes only */
    assertEqual(walk(warr, 1), 0x02u);
    assertEqual(walk(warr, 0), 0u);

    assertEqual(elem_lowbyte(warr, 0), 0x02);
    assertEqual(elem_lowbyte(warr, 2), 0x06);

    assertEqual(gate(&warr[0]), 2);        /* 0x02 < 0x04 */
    assertEqual(gate(&warr[1]), 1);        /* 0x04 == 0x04 */
    assertEqual(gate(&warr[2]), 3);        /* 0x06 > 0x04 */

    assertEqual(vol_lowbyte(), 0x55);

    /* A write through a narrowed load's global must still be seen whole. */
    wg = 0x9988u;
    assertEqual(g_lowbyte(), 0x88);
    assertEqual(wide_use(), 0x9988u);
    wg = 0x1234u;
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Byte-narrowed loads");
    suite_add_test(test_narrowld);
    return suite_run();
}
