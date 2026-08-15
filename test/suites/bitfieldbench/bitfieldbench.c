/*
 * bitfieldbench.c — packed bitfield extract and insert.
 *
 * A bitfield write is a full read-modify-write with no library call behind it:
 * load the storage unit, mask out the field, shift the new value into place, OR
 * it back, store. A read is a shift and a mask. Every instruction is a codegen
 * decision, which is what separates this from maskbench (explicit shifts on
 * whole words) and structbench (whole-byte members, no masking at all).
 *
 * The shapes are the ones that occur in real code: a control register split into
 * unequal fields, a field spanning a byte boundary, a single-bit flag, and a
 * field at offset zero where the shift folds away.
 *
 * Layout-independent by construction — bitfield allocation order is
 * implementation-defined, so the checksum only folds values written and read
 * back through the fields themselves, never the underlying storage. All fields
 * are unsigned, so there is no implementation-defined signedness either.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 300
#define REPS   26
#define CHK    60004u        /* host-verified (gcc -DHOST_VERIFY) */

/* A 32-bit control register, unequal fields, one crossing a byte boundary. */
struct reg {
    unsigned mode  : 3;      /* offset 0 — shift folds away on read */
    unsigned chan  : 5;      /* fills the first byte */
    unsigned rate  : 12;     /* spans bytes 1..2 */
    unsigned flag  : 1;      /* single bit */
    unsigned level : 7;
    unsigned spare : 4;
};

static struct reg regs[8];

/* Insert: five RMWs into the same storage, so the compiler has the chance to
   keep the unit live rather than reload it per field. */
static void reg_set(struct reg *r, unsigned int v)
{
    r->mode  = v & 7u;
    r->chan  = (v >> 3) & 31u;
    r->rate  = (v >> 4) & 4095u;
    r->flag  = (v >> 1) & 1u;
    r->level = (v >> 6) & 127u;
}

/* Extract: each read is a shift + mask; the offset-0 field needs only a mask. */
static unsigned int reg_get(const struct reg *r)
{
    unsigned int acc = 0;
    acc = (unsigned int)(acc + r->mode);
    acc = (unsigned int)(acc + (r->chan << 1));
    acc = (unsigned int)(acc + r->rate);
    acc = (unsigned int)(acc + (r->flag << 5));
    acc = (unsigned int)(acc + (r->level << 2));
    return acc & 0xffffu;
}

/* Read-modify-write in place: increment a field, test a flag, clear a field.
   The `f->rate++` form is the RMW the compiler cannot split. */
static unsigned int reg_step(struct reg *r)
{
    r->rate++;
    r->mode = (r->mode + 1u) & 7u;
    if (r->flag)
        r->level = (r->level + 3u) & 127u;
    else
        r->flag = 1;
    return reg_get(r);
}

static unsigned int bf_compute(void)
{
    unsigned int chk = 0, seed = 0x4D2Bu;
    int r, i, k;

    for (r = 0; r < REPS; r++) {
        for (k = 0; k < 8; k++)
            reg_set(&regs[k], (unsigned int)(k * 4241u));

        for (i = 0; i < STREAM; i++) {
            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            k = (int)((seed >> 4) & 7u);
            reg_set(&regs[k], seed);
            chk = (unsigned int)(chk + reg_step(&regs[k]));
            chk = (unsigned int)(chk + reg_get(&regs[(k + 3) & 7]));
            chk &= 0xffffu;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void bf_run(void)
{
    unsigned int chk = bf_compute();
    Assert(chk == CHK, "bitfield extract/insert checksum (host-verified)");
}

int suite_bitfield(void)
{
    suite_setup("Bitfield Tests");
    suite_add_test(bf_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_bitfield();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", bf_compute()); return 0; }
#endif
