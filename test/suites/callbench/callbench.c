/*
 * callbench.c — indirect calls and callback dispatch.
 *
 * A call through a function pointer is codegen rather than library work: the
 * compiler picks the index arithmetic for the pointer table, decides what has to
 * be saved around a callee it cannot see, and chooses how to hand control over.
 * switchbench measures the dense-switch form of dispatch; this measures the
 * table-of-pointers alternative to it.
 *
 *   dispatch  a pointer table indexed by a runtime opcode
 *   apply     a callback taken as a parameter and called in a loop, so the loop
 *             state has to survive an opaque call
 *   compose   a callback whose argument is itself an indirect call, so the
 *             save and restore discipline has to hold two deep
 *
 * The table has eight entries of two bytes each, which is the same stride as an
 * int array — a compiler that reduces `ints[k]` to `add hl,hl` should reduce
 * `ops[k]` the same way.
 *
 * Every result is masked to 16 bits, so the checksum is identical on target and
 * on the verifying host.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define STREAM 500
#define REPS   22
#define CHK    8252u           /* host-verified (gcc -DHOST_VERIFY) */

typedef unsigned int (*op_t)(unsigned int, unsigned int);

static unsigned int op_add(unsigned int a, unsigned int b) { return (a + b) & 0xffffu; }
static unsigned int op_sub(unsigned int a, unsigned int b) { return (a - b) & 0xffffu; }
static unsigned int op_xor(unsigned int a, unsigned int b) { return (a ^ b) & 0xffffu; }
static unsigned int op_and(unsigned int a, unsigned int b) { return (a & b) & 0xffffu; }
static unsigned int op_or (unsigned int a, unsigned int b) { return (a | b) & 0xffffu; }
static unsigned int op_mix(unsigned int a, unsigned int b) { return ((a << 1) ^ b) & 0xffffu; }
static unsigned int op_hi (unsigned int a, unsigned int b) { return ((a >> 3) + b) & 0xffffu; }
static unsigned int op_lo (unsigned int a, unsigned int b) { return ((a & 255u) | (b << 8)) & 0xffffu; }

static op_t ops[8] = { op_add, op_sub, op_xor, op_and,
                       op_or,  op_mix, op_hi,  op_lo };

/* Table dispatch: the pointer-table index arithmetic plus the indirect call. */
static unsigned int dispatch(unsigned int k, unsigned int a, unsigned int b)
{
    return ops[k & 7u](a, b);
}

/* The callee is a parameter, so nothing about it is known — the loop counter
   and accumulator both have to survive the call. */
static unsigned int apply(op_t f, unsigned int seed, int n)
{
    unsigned int acc = seed;
    int i;

    for (i = 0; i < n; i++)
        acc = f(acc, (unsigned int)(i * 7)) & 0xffffu;
    return acc;
}

/* Two opaque calls deep, with the inner result feeding the outer argument. */
static unsigned int compose(unsigned int k, unsigned int a)
{
    return dispatch(k + 1u, dispatch(k, a, a >> 2), a);
}

static unsigned int call_compute(void)
{
    unsigned int chk = 0, seed = 0x2F84u;
    int r, i;

    for (r = 0; r < REPS; r++) {
        for (i = 0; i < STREAM; i++) {
            unsigned int k;

            seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
            k = (seed >> 3) & 7u;

            chk = (unsigned int)(chk + dispatch(k, seed, seed >> 5));
            chk = (unsigned int)(chk + apply(ops[k], seed, 4));
            chk = (unsigned int)(chk + compose(k, seed));
            chk &= 0xffffu;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void call_run(void)
{
    unsigned int chk = call_compute();
    Assert(chk == CHK, "indirect call / dispatch checksum (host-verified)");
}

int suite_call(void)
{
    suite_setup("Indirect Call Tests");
    suite_add_test(call_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_call();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", call_compute()); return 0; }
#endif
