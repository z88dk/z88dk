/* GT/LE swap-load must preserve a register-resident RHS.
 *
 * `gt_arr[gi-1] > gt_arr[gi]` over a SORTED array is never an inversion.
 * The width-2 GT/LE compare uses a swap-load (DE=src0, HL=src1) so a single
 * `HL-DE` yields src1-src0 and CF=borrow means src0>src1. The old loader did
 * `load_to_de(src0); load_to_hl(src1)` raw: when src1 (gt_arr[gi]) was
 * already DE-resident, loading src0 evicted it from DE, and the src1 reload
 * found no spill slot — slot_off returned the -1 "no slot" sentinel, emitted
 * as `ld hl,-1; add hl,sp`, reading a word straddling below the frame. The
 * garbage RHS reported phantom inversions.
 *
 * A GLOBAL loop counter plus an in-loop call raise spill pressure (LICM
 * hoists both array-base loads) enough to leave the RHS register-resident
 * with no backing slot. This is the qsort verify-loop miscompile reduced;
 * a separate binary because long_ir.c is at the MSX 64K ceiling. */
#include "test.h"

static int gt_arr[5] = { 0, 1, 2, 3, 4 };
static int gt_gi, gt_sink;

static void gt_take(int a, int b) { gt_sink += a + b; }

static int gt_inversions(void)
{
    int bad = 0;
    for (gt_gi = 1; gt_gi < 5; ++gt_gi)
        if (gt_arr[gt_gi - 1] > gt_arr[gt_gi]) { bad++; gt_take(gt_gi, 7); }
    return bad;                  /* bug: nonzero (garbage sp-1 read) vs 0 */
}

/* gt_inversions() must run BEFORE the framework's suite_run() call chain:
   the below-frame word the bug reads is uninitialised stack, and the deep
   suite_run nesting leaves residue there that can mask the wrong answer.
   Run it first on the clean (zero-init) startup stack, then assert the
   captured count through the framework. */
static int gt_bad;

static void test_cmp_gt_resident(void)
{
    Assert(gt_bad == 0, "GT swap-load keeps DE-resident RHS (no -1 slot)");
}

int main(int argc, char *argv[])
{
    gt_bad = gt_inversions();
    suite_setup("GT/LE swap-load register-resident RHS");
    suite_add_test(test_cmp_gt_resident);
    return suite_run();
}
