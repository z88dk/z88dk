/* Post-render fold of `ld de,hl`/`ex de,hl` + `ld hl,<const-or-sym>` +
 * `add hl,de` into `ld de,<const-or-sym>` + `add hl,de` (ir_lower.c
 * fold_de_pool_remat_add, `[pool-remat-add-fold]`). The pattern is
 * commutative-add-with-one-remat-operand — same shape copt's 8085-only
 * `#ADDR` rule folds (see addridx.c's `%notcpu 8085` note) — but computed
 * here from real, branch-aware d_live/e_live liveness rather than a text
 * peephole, so it applies wherever the shape appears, not just on 8085.
 *
 * fire(): a struct-array field access. `idx * sizeof(item5)` (5, not a
 * power of 2) lowers to a shift-add chain whose intermediate the allocator
 * pools into DE purely to feed the array-base add — exactly the paint.c
 * shape (src/80cc/GBZ80_DE_RELOAD_PLAN.md) that motivated this fold. Proven
 * to actually exercise the fold (not just pass coincidentally) by diffing
 * `-a` output with IR_OFF=pool-remat-add-fold: the diff is exactly
 * `ld de,hl` + `ld hl,_items` -> `ld de,_items` on the affected line.
 *
 * bsearch_idx(): the valuable half — a case the fold must NOT fire on.
 * `mid` indexes `table[mid]` and is READ AGAIN immediately after
 * (`lo = mid + 1` / `hi = mid - 1`), so DE is genuinely live past the
 * `add hl,de` that forms `&table[mid]`. Extracted from a real benchmark
 * (searchbench.c) that a corpus-wide IR_DEBUG_FOLD_VETO instrumentation
 * pass confirmed hits the fold's liveness veto (d_live=1 e_live=1) on
 * every clib family tried (z80, gbz80, 8080, 8085) — this is not a
 * hypothetical shape.
 *
 * A wrong fold here does not abort — it hands the array base back where
 * the index is expected, so `mid`'s next read silently gets the address of
 * `table` (or its low bytes) instead of the bisection midpoint, and the
 * search walks off narrowing correctly by chance or not at all. The
 * assertEqual calls below catch that as a wrong return value, not a crash.
 */
#include "test.h"

typedef struct { unsigned char a,b,c,d,e; } item5;
static item5 items[40];

static unsigned int fire(unsigned int idx)
{
    return items[idx].c;
}

#define N 512
static int table[N];

static int bsearch_idx(int key)
{
    int lo = 0, hi = N - 1;
    while (lo <= hi) {
        int mid = (lo + hi) >> 1;
        int v = table[mid];
        if (v == key) return mid;
        if (v < key) lo = mid + 1;
        else         hi = mid - 1;
    }
    return -1;
}

static void test_poolremat(void)
{
    unsigned int i;
    int j;

    for (i = 0; i < 40; i++) items[i].c = (unsigned char)(i * 3);
    assertEqual(fire(7), 21);
    assertEqual(fire(0), 0);
    assertEqual(fire(39), 117);

    for (j = 0; j < N; j++) table[j] = j * 3;
    assertEqual(bsearch_idx(30), 10);
    assertEqual(bsearch_idx(0), 0);
    assertEqual(bsearch_idx(1530), 510);
    assertEqual(bsearch_idx(31), -1);
    assertEqual(bsearch_idx(-1), -1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Post-render DE-pool/remat-add fold");
    suite_add_test(test_poolremat);
    return suite_run();
}
