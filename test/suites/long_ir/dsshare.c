/* Dead-store elision across a COALESCED slot (IR_DS_SHARE).
 *
 * ir_slots coalesces two spill vregs into one frame slot only when their live
 * ranges do not interfere, so a reader sharing a slot with a dead store is
 * normally served by its own store, not by the dead one. IR_DS_SHARE stops
 * vetoing those. It must keep vetoing exactly one shape:
 *
 *     a reader with MORE THAN ONE DEF, where one def stores the slot and
 *     another rides a register.
 *
 * On the register-riding path nothing writes the slot, so the read is served by
 * whatever was left there -- which is the store the elision wanted to drop.
 * Eliding it returns a stale value on that path only, which is why this is a
 * wrong ANSWER and not a crash.
 *
 * `rd_reg` / `wr_reg` are emu.c's read_reg / write_reg reduced to that shape:
 * `ptr` is defined in two branches and then read through a switch, with the
 * accessors kept as calls because a call result committed to a slot is what
 * coalesces with `ptr`. Those two functions are where the first (unsound)
 * version of IR_DS_SHARE broke emu.c.
 *
 * HONEST LIMIT: this file does NOT catch that unsound version. Checked
 * directly -- compiled with the loose predicate (self_served = slot written at
 * all, ignoring the def count) it makes byte-for-byte the same elision
 * decisions as the shipped one, so no assertion here could tell them apart.
 * The shape needs emu.c's surrounding register pressure to actually coalesce.
 * What this pins is the shape and its answers across four CPUs and both frame
 * modes; the gate that catches the miscompile is the emu.c behavioural run,
 * both modes, exactly as the #10 slot-coalescing bug found the first time.
 *
 * No printf: it perturbs allocation and can mask exactly this.
 */
#include "test.h"

static unsigned long dreg[8];
static unsigned long areg[8];
static int fatal_count;

static void bad_reg(void) { fatal_count++; }

/* Read/write helpers are CALLS, as in emu.c — a call result committed to a
   slot is the commonest dead-store shape there is, and it is what coalesces
   with `ptr` here. Without them the slot never gets shared and the shape below
   does not arise at all. */
static unsigned int rd_w(unsigned char *p)
{
    return (unsigned int)(((unsigned int)p[0] << 8) | p[1]);
}
static unsigned long rd_l(unsigned char *p)
{
    return ((unsigned long)p[0] << 24) | ((unsigned long)p[1] << 16)
         | ((unsigned long)p[2] << 8)  | (unsigned long)p[3];
}
static void wr_w(unsigned char *p, unsigned int v)
{
    p[0] = (unsigned char)(v >> 8);
    p[1] = (unsigned char)v;
}
static void wr_l(unsigned char *p, unsigned long v)
{
    p[0] = (unsigned char)(v >> 24);
    p[1] = (unsigned char)(v >> 16);
    p[2] = (unsigned char)(v >> 8);
    p[3] = (unsigned char)v;
}

/* Big-endian access into the register file, like the 68000 emulator's. */
static unsigned long rd_reg(unsigned char i, unsigned char s)
{
    unsigned char *ptr;

    if (i > 15) { bad_reg(); return 0; }
    if (i < 8) ptr = (unsigned char *)&dreg[i];        /* def 1 */
    else       ptr = (unsigned char *)&areg[i - 8];    /* def 2 */

    switch (s) {
    case 0:
        return (unsigned long)ptr[3];
    case 1:
        return (unsigned long)rd_w(ptr + 2);
    default:
        return rd_l(ptr);
    }
}

static void wr_reg(unsigned char i, unsigned char s, unsigned long v)
{
    unsigned char *ptr;

    if (i > 15) { bad_reg(); return; }
    if (i < 8) ptr = (unsigned char *)&dreg[i];        /* def 1 */
    else       ptr = (unsigned char *)&areg[i - 8];    /* def 2 */

    switch (s) {
    case 0:
        ptr[3] = (unsigned char)v;
        break;
    case 1:
        wr_w(ptr + 2, (unsigned int)v);
        break;
    default:
        wr_l(ptr, v);
        break;
    }
}

/* A second multi-def pointer shape, this one with a loop so the def that rides
   a register and the def that stores are in different iterations. */
static unsigned char buf_a[4] = { 1, 2, 3, 4 };
static unsigned char buf_b[4] = { 10, 20, 30, 40 };

static unsigned int walk_pick(int n)
{
    unsigned int acc = 0;
    int k;
    for (k = 0; k < n; k++) {
        unsigned char *p;
        if (k & 1) p = buf_a;          /* def 1 */
        else       p = buf_b;          /* def 2 */
        acc = (unsigned int)(acc + p[k & 3]);
    }
    return acc;
}

static void test_dsshare(void)
{
    int i;

    for (i = 0; i < 8; i++)  dreg[i] = 0;
    for (i = 0; i < 8; i++)  areg[i] = 0;

    /* Long writes, then read back at all three sizes through BOTH branches. */
    wr_reg(0,  2, 0x11223344UL);      /* dreg[0] */
    wr_reg(8,  2, 0xAABBCCDDUL);      /* areg[0] */
    wr_reg(15, 2, 0x01020304UL);      /* areg[7] */

    assertEqual(rd_reg(0,  2) == 0x11223344UL, 1);
    assertEqual(rd_reg(8,  2) == 0xAABBCCDDUL, 1);
    assertEqual(rd_reg(15, 2) == 0x01020304UL, 1);

    assertEqual(rd_reg(0,  1), 0x3344);
    assertEqual(rd_reg(8,  1), 0xCCDD);
    assertEqual(rd_reg(15, 1), 0x0304);

    assertEqual(rd_reg(0,  0), 0x44);
    assertEqual(rd_reg(8,  0), 0xDD);
    assertEqual(rd_reg(15, 0), 0x04);

    /* Byte and word writes must land in the right array, at the byte the
       big-endian view names -- checked through the byte view, not the native
       long, so the assertion does not depend on host byte order. */
    wr_reg(3, 0, 0x7f);
    assertEqual(rd_reg(3, 0), 0x7f);
    assertEqual(((unsigned char *)&dreg[3])[3], 0x7f);
    assertEqual(((unsigned char *)&dreg[3])[0], 0);
    assertEqual(rd_reg(11, 0), 0);          /* the OTHER array is untouched */

    wr_reg(11, 1, 0xbeef);
    assertEqual(rd_reg(11, 1), 0xbeef);
    assertEqual(((unsigned char *)&areg[3])[2], 0xbe);
    assertEqual(((unsigned char *)&areg[3])[3], 0xef);
    assertEqual(rd_reg(3, 0), 0x7f);        /* dreg side still intact */

    /* Out of range: neither branch runs, nothing is touched. */
    fatal_count = 0;
    assertEqual(rd_reg(16, 2) == 0UL, 1);
    wr_reg(16, 2, 0xffffffffUL);
    assertEqual(fatal_count, 2);
    assertEqual(rd_reg(0, 2) == 0x11223344UL, 1);

    /* 10+2+30+4 + 10 = ... walked explicitly below. */
    assertEqual(walk_pick(0), 0);
    assertEqual(walk_pick(1), 10);            /* k=0 -> buf_b[0] */
    assertEqual(walk_pick(2), 12);            /* + buf_a[1]=2 */
    assertEqual(walk_pick(4), 46);            /* + buf_b[2]=30 + buf_a[3]=4 */
    assertEqual(walk_pick(5), 56);            /* + buf_b[0]=10 */
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Dead-store elision across a coalesced slot");
    suite_add_test(test_dsshare);
    return suite_run();
}
