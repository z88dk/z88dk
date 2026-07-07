/*
 * recordbench.c — stationary struct-pointer field churn, compiler comparison.
 *
 * A single hot struct pointer with heavy read/write field traffic — the
 * state-machine / record-update shape:
 *     for (i) { p->a = p->a+p->b; p->c ^= p->a; if (p->c&1) p->d+=p->e ... }
 *
 * The base pointer never moves, so this is the pure (iy+d) case (no stepping):
 * with `p` in an index register every field is a single `(iy+d)` access; without
 * it, `p` is reloaded and each `p->field` recomputes base+offset. Complements
 * structbench (which walks) — here the win is purely constant-offset addressing.
 *
 * All field values are 15-bit-masked and the checksum 16-bit-masked, so it
 * matches on a 16-bit target and a 32-bit host.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define ITERS  6000
#define CHK    4389u        /* host-verified */

struct st { int a, b, c, d, e; };
static struct st S;

static unsigned int churn(struct st *p, int it)
{
    unsigned int chk = 0;
    int i;
    for (i = 0; i < it; i++) {
        p->a = (p->a + p->b) & 0x7fff;
        p->c = (p->c ^ p->a);
        if (p->c & 1) p->d = (p->d + p->e) & 0x7fff;
        else          p->e = (p->e + p->a) & 0x7fff;
        p->b = (p->b + p->c) & 0x7fff;
        chk = (chk + (unsigned int)p->a + (unsigned int)p->d) & 0xffffu;
    }
    return chk;
}

static void record_run(void)
{
    S.a = 1; S.b = 2; S.c = 3; S.d = 4; S.e = 5;
    Assert(churn(&S, ITERS) == CHK, "struct-pointer field churn checksum (host-verified)");
}

int suite_record(void)
{
    suite_setup("Record field-churn Tests");
    suite_add_test(record_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_record();
    exit(res);
}
