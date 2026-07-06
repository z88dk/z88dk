/* Byte-wise (ix+d) operand fold for int compares. In fp mode (-frameix) an int
 * compare whose operands live in (ix+d) slots / idx2 halves / register pairs is
 * lowered by reading each operand's bytes IN PLACE and subtracting through A
 * (`ld a,<lo>; sub <lo'>; ld a,<hi>; sbc a,<hi'>` + S^V for signed), instead of
 * staging a slot into a pair + `sbc hl,de`. Gated to z80/z80n/z180.
 *
 * These tiny functions keep both operands as (ix+d) PARAM_IN_PLACE slots, so the
 * fp build exercises the both-operands-folded byte-wise path across ALL six
 * relations + signed/unsigned; the asserts are width-independent so the sp build
 * (fold inert) validates the ordinary path too. Correctness traps: the M-N
 * subtraction direction, the CF/!CF branch polarity, the S^V signed correction
 * (negative + overflow operands), the LE/GT reduction to strict-less-of-reversed,
 * and the two-byte EQ check (low- vs high-byte differences). */
#include "test.h"

static int slt(int a, int b) { if (a <  b) return 1; return 0; }
static int sle(int a, int b) { if (a <= b) return 1; return 0; }
static int sgt(int a, int b) { if (a >  b) return 1; return 0; }
static int sge(int a, int b) { if (a >= b) return 1; return 0; }
static int seq(int a, int b) { if (a == b) return 1; return 0; }
static int sne(int a, int b) { if (a != b) return 1; return 0; }

static int ult(unsigned a, unsigned b) { if (a <  b) return 1; return 0; }
static int ule(unsigned a, unsigned b) { if (a <= b) return 1; return 0; }
static int ugt(unsigned a, unsigned b) { if (a >  b) return 1; return 0; }
static int uge(unsigned a, unsigned b) { if (a >= b) return 1; return 0; }

static void test_ixdcmp(void)
{
    /* Signed ordered, incl. negatives. */
    Assert(slt(-5, 3) == 1 && slt(3, -5) == 0 && slt(4, 4) == 0, "signed <");
    Assert(sle(4, 4) == 1 && sle(4, 5) == 1 && sle(5, 4) == 0,   "signed <=");
    Assert(sgt(3, -5) == 1 && sgt(-5, 3) == 0 && sgt(4, 4) == 0, "signed >");
    Assert(sge(4, 4) == 1 && sge(5, 4) == 1 && sge(4, 5) == 0,   "signed >=");
    /* Signed overflow region — the S^V correction is what makes these right. */
    Assert(slt(-32768, 32767) == 1, "signed < across the overflow boundary");
    Assert(sge(-32768, 32767) == 0, "signed >= across the overflow boundary");
    Assert(sgt(32767, -32768) == 1, "signed > across the overflow boundary");
    Assert(sle(32767, -32768) == 0, "signed <= across the overflow boundary");
    /* Equality — low-byte vs high-byte differences. */
    Assert(seq(0x1234, 0x1234) == 1, "== equal");
    Assert(seq(0x1234, 0x1235) == 0, "== low byte differs");
    Assert(seq(0x1234, 0x1334) == 0, "== high byte differs");
    Assert(seq(-1, -1) == 1,         "== negative equal");
    Assert(sne(0x1234, 0x1235) == 1 && sne(0x1234, 0x1234) == 0, "!=");
    /* Unsigned ordered, incl. high-bit values (would misorder if treated signed). */
    Assert(ult(3, 50000u) == 1 && ult(50000u, 3) == 0,          "unsigned <");
    Assert(ule(50000u, 50000u) == 1 && ule(50001u, 50000u) == 0, "unsigned <=");
    Assert(ugt(50000u, 3) == 1 && ugt(3, 50000u) == 0,          "unsigned >");
    Assert(uge(50000u, 50000u) == 1 && uge(3, 50000u) == 0,     "unsigned >=");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Byte-wise (ix+d) int compare fold");
    suite_add_test(test_ixdcmp);
    return suite_run();
}
