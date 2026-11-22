/* A PARAMETER'S INCOMING VALUE IS AN INVISIBLE DEF.
 *
 * Rematerialisation replaces a spill/reload with a recompute when a vreg has
 * exactly ONE defining op and that op is a constant (LD_IMM) or a symbol
 * address (LD_SYM). The def count is taken over the ops in THIS function — but
 * a parameter also carries the caller's value, which has no def op at all. So a
 * parameter assigned once, under a condition, counts as single-def-constant and
 * is not:
 *
 *     int floor0(int v) { if (v < 0) v = 0; return v + 1; }
 *
 * remat took the `LD_IMM 0` as v's defining value, so every read of v became
 * `ld hl,0` and the parameter was never loaded at all:
 *
 *     ._floor0
 *         ld hl,0        <- the PARAMETER, materialised as the constant
 *         ld a,h / add a,a / jr nc,L
 *         ld hl,0
 *     L:  inc hl / ret
 *
 * floor0(5) returned 1 instead of 6, on every CPU and in both frame modes,
 * while floor0(-7) was correct — so the answer is only wrong on the path where
 * the conditional assignment does NOT run. `--opt-disable=remat` was the
 * workaround; the fix adds IR_VREG_PARAM to remat's exclusion list beside
 * ADDR_TAKEN and VOLATILE.
 *
 * Using a local copy is unaffected (`via_local` below) — that gives the
 * constant a genuine single def — which is why this shape hid: the same
 * function written with a temporary is correct.
 */
#include "test.h"

/* The original. One conditional assignment to the parameter, then a read. */
static int floor0(int v)      { if (v < 0) v = 0; return v + 1; }

/* Read the parameter back directly, no arithmetic after it. */
static int floor0_id(int v)   { if (v < 0) v = 0; return v; }

/* The condition inverted, so the assignment runs for POSITIVE inputs — pins
   that the fix did not simply invert which path is wrong. */
static int ceil0(int v)       { if (v > 0) v = 0; return v + 1; }

/* A symbol address rather than a constant: the other remat kind. */
static int tbl[4] = { 10, 20, 30, 40 };
static int pick(int *p, int flag)
{
    if (flag) p = tbl;
    return p[1];
}

/* The local-copy form, correct even with the bug present — so a pass here
   proves nothing alone; it pins that the fix did not break the ordinary case. */
static int via_local(int v)   { int w = v; if (w < 0) w = 0; return w + 1; }

/* Two conditional assignments, the predbench/depark `sat` shape. */
static int clamp(int v)
{
    if (v > 255) v = 255;
    if (v < 0)   v = 0;
    return v;
}

static void test_parremat(void)
{
    /* the path where the assignment does NOT run is the one that was wrong */
    assertEqual(floor0(5),    6);
    assertEqual(floor0(1),    2);
    assertEqual(floor0(0),    1);
    assertEqual(floor0(-7),   1);
    assertEqual(floor0(-1),   1);

    assertEqual(floor0_id(5),  5);
    assertEqual(floor0_id(-5), 0);

    assertEqual(ceil0(5),   1);
    assertEqual(ceil0(0),   1);
    assertEqual(ceil0(-4), -3);

    {
        static int other[4] = { 1, 2, 3, 4 };
        assertEqual(pick(other, 0), 2);    /* p keeps the argument */
        assertEqual(pick(other, 1), 20);   /* p = tbl */
    }

    assertEqual(via_local(5),  6);
    assertEqual(via_local(-5), 1);

    assertEqual(clamp(300), 255);
    assertEqual(clamp(100), 100);
    assertEqual(clamp(-9),    0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("A parameter's incoming value is an invisible def");
    suite_add_test(test_parremat);
    return suite_run();
}
