/*
 * ptrbench.c — pointer/addressing-heavy benchmark for compiler
 * comparison. Mirrors the structure of intbench / crcbench but the
 * hot loops exercise the four patterns the pending pointer-addressing
 * walker tasks target:
 *
 *   1. index_walk    — `for (i=0; i<N; i++) sum += arr[i]` — the
 *      canonical indexed-array walk. Targets #127 (arr[i] strength
 *      reduction to a stepped pointer). Without strength reduction
 *      the walker emits a fresh address compute (`ld hl,_arr` + `add
 *      hl,bc` + scale) per iteration.
 *
 *   2. matrix_walk   — `for (i) for (j) sum += m[i][j]` — nested
 *      indexed walk on a flat 2D array. Stresses chained scale-and-
 *      add per inner iteration. Same #127 target, plus the outer-
 *      loop offset stays constant inside the inner loop (gives a
 *      reuse hit for #226 if we coalesce repeated `add hl,sp`).
 *
 *   3. struct_field_sum — `s[i].a + s[i].b + s[i].c + s[i].d` —
 *      array of 4-field int structs. Each field read recomputes the
 *      base address of `s[i]` because the walker has no live-base
 *      tracking. Target for #226 (coalesce repeated base compute)
 *      and #242 (keep the struct base in BC across the four reads).
 *
 *   4. multi_deref   — `f(p)` reads `p->a + p->b + p->c + p->d` —
 *      same as struct_field_sum but with a *pointer* base instead
 *      of an indexed local. Walker currently reloads `p` from the
 *      stack four times via `l_gintNsp`; target for #242 (load `p`
 *      into BC once, walk fields off BC).
 *
 * Deterministic 1 KB seed shared with the existing benches; the
 * data shapes differ but the buffer fill keeps cache behaviour
 * comparable.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define BUF_LEN     1024
#define ARR_LEN     256        /* 256 ints = 512 bytes = ~half BUF */
#define MAT_DIM     16         /* 16 x 16 = 256 ints */
#define STRUCT_LEN  64         /* 64 × 8-byte structs = 512 B, 256 ints = same sum as arr */
#define REPS        63

static unsigned char buffer[BUF_LEN];

struct rec { int a, b, c, d; };

static int           arr[ARR_LEN];
static int           mat[MAT_DIM][MAT_DIM];
static struct rec    recs[STRUCT_LEN];

/* ---------------- 1. arr[i] index walk ---------------- */
static int index_walk_int(int *a, int n)
{
    int i, sum;
    sum = 0;
    for (i = 0; i < n; i++) sum += a[i];
    return sum;
}

/* ---------------- 2. nested matrix walk --------------- */
/* Parameter form: `m` decays to `int(*)[N]` at the call boundary,
   so accesses `m[i][j]` go through pointer arithmetic. Exercises
   the runtime-index scale path. */
static int matrix_walk(int m[MAT_DIM][MAT_DIM])
{
    int i, j, sum;
    sum = 0;
    for (i = 0; i < MAT_DIM; i++) {
        for (j = 0; j < MAT_DIM; j++) {
            sum += m[i][j];
        }
    }
    return sum;
}

/* Direct-access form: `mat` is the global int[N][N], so the row
   address `mat + i*N` retains its array type — LICM hoists it out
   of the inner j-loop via the array→pointer decay path. */
static int matrix_walk_global(void)
{
    int i, j, sum;
    sum = 0;
    for (i = 0; i < MAT_DIM; i++) {
        for (j = 0; j < MAT_DIM; j++) {
            sum += mat[i][j];
        }
    }
    return sum;
}

/* ---------------- 3. struct-array field sum ----------- */
static int struct_field_sum(struct rec *s, int n)
{
    int i, sum;
    sum = 0;
    for (i = 0; i < n; i++) {
        sum += s[i].a + s[i].b + s[i].c + s[i].d;
    }
    return sum;
}

/* ---------------- 4. multi-deref same pointer --------- */
static int multi_deref_one(struct rec *p)
{
    return p->a + p->b + p->c + p->d;
}

static int multi_deref(struct rec *s, int n)
{
    int i, sum;
    sum = 0;
    for (i = 0; i < n; i++) sum += multi_deref_one(&s[i]);
    return sum;
}

/* ---------------- buffer / data init ------------------ */
static void init_data(void)
{
    unsigned int i;
    unsigned int seed = 0xC001U;
    /* Same fill as intbench / crcbench. */
    for (i = 0; i < BUF_LEN; i++) {
        buffer[i] = (unsigned char)(seed & 0xFFU);
        seed = (unsigned int)(seed * 25173U + 13849U);
    }
    /* Reuse the buffer as int / struct fills. */
    for (i = 0; i < ARR_LEN; i++) {
        arr[i] = ((int)buffer[(i*2)+0]) | (((int)buffer[(i*2)+1]) << 8);
    }
    for (i = 0; i < MAT_DIM * MAT_DIM; i++) {
        ((int *)mat)[i] = arr[i];
    }
    for (i = 0; i < STRUCT_LEN; i++) {
        recs[i].a = arr[(i*4)+0];
        recs[i].b = arr[(i*4)+1];
        recs[i].c = arr[(i*4)+2];
        recs[i].d = arr[(i*4)+3];
    }
}

static void ptrbench_run(void)
{
    int rep;
    int sum;

    init_data();

    /* Each kernel runs REPS times so the inner-loop cost dominates. */

    sum = 0;
    for (rep = 0; rep < REPS; rep++) sum += index_walk_int(arr, ARR_LEN);
    assertEqual(sum, (int)0x8000);   /* host-computed */

    sum = 0;
    for (rep = 0; rep < REPS; rep++) sum += matrix_walk(mat);
    assertEqual(sum, (int)0x8000);

    sum = 0;
    for (rep = 0; rep < REPS; rep++) sum += matrix_walk_global();
    assertEqual(sum, (int)0x8000);

    sum = 0;
    for (rep = 0; rep < REPS; rep++) sum += struct_field_sum(recs, STRUCT_LEN);
    assertEqual(sum, (int)0x8000);

    sum = 0;
    for (rep = 0; rep < REPS; rep++) sum += multi_deref(recs, STRUCT_LEN);
    assertEqual(sum, (int)0x8000);
}

int suite_ptrbench(void)
{
    suite_setup("PTR-bench Tests");
    suite_add_test(ptrbench_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_ptrbench();
    exit(res);
}
