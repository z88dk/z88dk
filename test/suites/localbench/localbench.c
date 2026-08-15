/*
 * localbench.c — frame-resident arrays and structs.
 *
 * Every other bench in the corpus keeps its data in static storage, where an
 * element address is an absolute constant plus an index. A LOCAL aggregate is
 * addressed off the frame instead, and the z80 has no `add hl,ix` — so the base
 * has to be reconstructed for each dynamic index, either by `push ix; pop hl` or
 * by `ld hl,off; add hl,sp`.
 *
 *   scratch  a local int array indexed by a runtime value, read and written
 *   record   a local struct with heavy field traffic — recordbench's shape, but
 *            on the frame rather than in static storage
 *   escaped  a local whose address is passed to a callee, so the slot must be
 *            real and cannot be kept in a register across the call
 *
 * This is the shape that decides frame-pointer against stack-relative
 * addressing, so it is the one bench whose fp and sp numbers should differ.
 *
 * All values are masked so the checksum is identical on a 16-bit-int target and
 * the verifying host.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 400
#define REPS   22
#define CHK    28521u          /* host-verified (gcc -DHOST_VERIFY) */

struct rec { int a, b, c, d; };

/* Dynamic index into a frame array: the base is a frame offset, so every
   subscript needs the frame register brought into an addressable pair. */
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

/* Field traffic on a frame-resident struct: constant offsets from the frame,
   which is the case a frame pointer is supposed to be good at. */
static unsigned int record(unsigned int seed)
{
    struct rec r;
    int i;

    r.a = (int)(seed & 255u);
    r.b = (int)((seed >> 4) & 255u);
    r.c = (int)((seed >> 8) & 255u);
    r.d = 0;

    for (i = 0; i < 8; i++) {
        r.d = (r.d + r.a) & 4095;
        r.a = (r.a ^ r.b) & 255;
        r.b = (r.b + r.c + i) & 255;
        r.c = (r.c ^ r.d) & 255;
    }
    return (unsigned int)((r.a + r.b + r.c + r.d) & 0xffff);
}

static void bump(int *p, int k) { *p = (*p + k) & 0x3fff; }

/* Address-taken locals: `&v` and `&t[i]` force real frame slots, so nothing here
   can be register-homed across the call. */
static unsigned int escaped(unsigned int seed)
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

static unsigned int local_compute(void)
{
    unsigned int chk = 0, seed = 0x51A9u;
    int r, i;

    for (r = 0; r < REPS; r++) {
        for (i = 0; i < STREAM; i++) {
            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            chk = (unsigned int)(chk + scratch(seed));
            chk = (unsigned int)(chk + record(seed));
            chk = (unsigned int)(chk + escaped(seed));
            chk &= 0xffffu;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void local_run(void)
{
    unsigned int chk = local_compute();
    Assert(chk == CHK, "frame-resident aggregate checksum (host-verified)");
}

int suite_local(void)
{
    suite_setup("Frame-Resident Aggregate Tests");
    suite_add_test(local_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_local();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", local_compute()); return 0; }
#endif
