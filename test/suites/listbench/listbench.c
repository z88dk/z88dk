/*
 * listbench.c — linked-list pointer chasing, compiler comparison.
 *
 * The anti-ptrbench: ptrbench walks an array with a constant stride, which the
 * compiler strength-reduces to a stepped pointer. Here the traversal follows
 * `p = p->next` through a scrambled permutation, so NO stride exists and
 * strength reduction / IVSR cannot help. The hot path is pure deref-chain
 * codegen:
 *
 *     while (p) { sum += p->val; p = p->next; }
 *
 * i.e. load a field at an offset, load the next pointer at an offset, test for
 * NULL, branch — exposing raw pointer-residency (does `p` stay in a register
 * across the field load?) with no addressing tricks available.
 *
 * Nodes live in a static array (no malloc). Links form a single cycle via a
 * stride coprime to N (division-free build); the list is then NULL-terminated.
 * Checksum is width-independent (16-bit masked) and host-verified.
 */
#include <stdlib.h>
#ifndef HOST_VERIFY
#include "test.h"
#endif

#define N     500
#define STEP  137            /* gcd(137,500)=1 → single full cycle */
#define REPS  220
#define CHK   12000u         /* host-verified (gcc -DHOST_VERIFY) */

typedef struct node {
    struct node *next;
    unsigned int val;
} node;

static node nodes[N];
static int   order[N];

static unsigned int list_compute(void)
{
    unsigned int chk = 0, seed = 0xBEEFu;
    int k, r;
    int idx = 0;
    node *head;

    /* Visit order: coprime stride → one cycle covering every node (no div). */
    for (k = 0; k < N; k++) {
        order[k] = idx;
        idx += STEP;
        if (idx >= N) idx -= N;
    }
    for (k = 0; k < N - 1; k++)
        nodes[order[k]].next = &nodes[order[k + 1]];
    nodes[order[N - 1]].next = (node *)0;
    head = &nodes[order[0]];

    for (k = 0; k < N; k++) {
        seed = (unsigned int)((seed * 25173u + 13849u) & 0xffffu);
        nodes[k].val = seed;
    }

    for (r = 0; r < REPS; r++) {
        node *p = head;
        /* read pass: sum the chased fields */
        while (p) {
            chk = (unsigned int)((chk + p->val) & 0xffffu);
            p = p->next;
        }
        /* write pass: bump each field through the same chase */
        p = head;
        while (p) {
            p->val = (unsigned int)((p->val + 3u) & 0xffffu);
            p = p->next;
        }
    }
    return chk & 0xffffu;
}

#ifndef HOST_VERIFY
static void list_run(void)
{
    unsigned int chk = list_compute();
    Assert(chk == CHK, "linked-list pointer-chase checksum (host-verified)");
}

int suite_list(void)
{
    suite_setup("Linked-List Pointer-Chase Tests");
    suite_add_test(list_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    (void)argc; (void)argv;
    res += suite_list();
    exit(res);
}
#else
#include <stdio.h>
int main(void) { printf("%u\n", list_compute()); return 0; }
#endif
