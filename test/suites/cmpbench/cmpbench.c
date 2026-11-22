/*
 * cmpbench.c — relational operators whose result is a value.
 *
 * predbench uses a compare as control flow (if, &&, ?:) and can leave the
 * result in the flags. The expressions here are values. Each one is added
 * into an accumulator. That is the shape of a long run of
 *
 *     expect(name, rc == 0xFF && p[14] == 0 && p[1] == 'N');
 *
 * when the callee takes an int and the test is compiled at the call.
 *
 * 80cc stores every relational, and each && that joins them, as a byte:
 *
 *     ld a,0
 *     jr cc,ASMPC+3          ; jp cc,ASMPC+4 on 8080 and 8085
 *     inc a
 *
 * sccz80 compares and jumps to the failure label (cp and jp on Z80,
 * l_eq_hlbc for the word compare on 8085) and writes 0 or 1 once for
 * the whole chain. -O2 does not remove the 80cc sequence.
 *
 * One copy inside a loop hides that cost. Each ARM below is its own
 * expression, and the constants differ so the copies stay separate.
 * The checksum checks the value. Short-circuit behaviour is predbench.
 *
 * The signed relations sit in the same function as the && chains.
 * One arm compares an unsigned char with (unsigned char)(0xFF + 1).
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STEPS  64
#define REPS   20
#define CHK    3720u         /* host-verified (gcc -DHOST_VERIFY) */

static unsigned char cell[32];

/* n, rc and p are the locals in value_cmp. */
#define ARM(k, ia, ib) \
    n += (rc == (unsigned)(k) && p[ia] == (unsigned char)(k) \
          && p[ib] != (unsigned char)((k) + 1))

static unsigned int value_cmp(unsigned char *p, unsigned int rc, int a, int b, int c)
{
    unsigned int n = 0;

    ARM(0x00FF,  0,  7);
    ARM(0x0000,  3, 12);
    ARM(0x0001,  6, 17);
    ARM(0x0080,  9, 22);
    ARM(0x00E5, 12, 27);
    ARM(0x005A, 15,  0);
    ARM(0x00EB, 18,  5);
    ARM(0x003C, 21, 10);
    ARM(0x0090, 24, 15);
    ARM(0x0055, 27, 20);
    ARM(0x00AA, 30, 25);
    ARM(0x00F8,  1, 30);
    ARM(0x0010,  4,  3);
    ARM(0x0020,  7,  8);
    ARM(0x007F, 10, 13);
    ARM(0x000D, 13, 18);

    n += (a < b);
    n += (a > c);
    n += (a <= b);
    n += (b >= c);
    n += (a == c);
    n += (b != a);
    return n & 0xffffu;
}

static unsigned int cmp_compute(void)
{
    unsigned int chk = 0;
    unsigned int s;
    int r, i;

    for (i = 0; i < 32; i++)
        cell[i] = (unsigned char)(i * 13 + 5);
    for (r = 0; r < REPS; r++) {
        for (s = 0; s < STEPS; s++) {
            int a = (int)(s & 15) - 8;
            int b = (int)((s >> 2) & 15) - 7;
            int c = (int)((s >> 4) & 7);
            chk = (chk + value_cmp(cell, s, a, b, c)) & 0xffffu;
        }
    }
    return chk;
}

#ifndef HOST_VERIFY
static void cmp_run(void)
{
    unsigned int chk = cmp_compute();
    Assert(chk == CHK, "value-context compare checksum (host-verified)");
}

int suite_cmp(void)
{
    suite_setup("Value Compare Tests");
    suite_add_test(cmp_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_cmp();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", cmp_compute()); return 0; }
#endif
