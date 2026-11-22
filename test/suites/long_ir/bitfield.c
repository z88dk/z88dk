/* Compound assignment on a bitfield (`bf op= x`) must read-modify-write the
   field at its bit offset, not the whole storage unit. ir_build's compound
   handler (OP_AADD/OP_AOR/...) had no bitfield case, so `g.b |= 1` for a
   field at bit offset 3 ORed bit 0 of the unit (a neighbour) and left b
   unchanged. Now it routes through emit_bitfield_store (shared with `bf = x`).
   Globals exercise the LD_SYM RMW path; the asserts check both the field
   result and that neighbouring fields in the same unit are untouched.
   Plain `int:N` is UNSIGNED in the z88dk dialect (matches sccz80), so signed
   cases use `signed int`. Own binary: long_ir.c is at the MSX 64K ceiling. */
#include "test.h"

struct bf {
    unsigned a : 3;     /* bits 0-2  */
    unsigned b : 5;     /* bits 3-7  */
    unsigned c : 4;     /* bits 8-11 */
    unsigned d : 10;    /* bits 12-21 — crosses a byte boundary */
};
static struct bf g;

static void test_bf_compound_or(void)
{
    g.a = 5; g.b = 20;
    g.b |= 1;                       /* 20 -> 21, must not touch a */
    Assert(g.b == 21, "bitfield |= sets the field's own bits");
    Assert(g.a == 5,  "bitfield |= leaves the neighbour field");
}

static void test_bf_compound_after_neighbour(void)
{
    g.a = 5; g.b = 20;
    g.a += 2;                       /* a: 5 -> 7 (RMW of the shared byte) */
    g.b |= 1;                       /* b: 20 -> 21 — was lost when a was written first */
    Assert(g.a == 7,  "neighbour compound add");
    Assert(g.b == 21, "compound |= after a neighbour write");
}

static void test_bf_compound_ops(void)
{
    g.b = 20;  g.b += 3;  Assert(g.b == 23, "bitfield +=");
    g.b = 20;  g.b -= 4;  Assert(g.b == 16, "bitfield -=");
    g.b = 0x1f; g.b &= 0x15; Assert(g.b == 0x15, "bitfield &=");
    g.b = 0x10; g.b ^= 0x05; Assert(g.b == 0x15, "bitfield ^=");
    g.b = 1;   g.b <<= 3;  Assert(g.b == 8,  "bitfield <<=");
    g.b = 16;  g.b >>= 2;  Assert(g.b == 4,  "bitfield >>=");
}

static void test_bf_compound_wide(void)
{
    /* d crosses the byte boundary (word-unit RMW). */
    g.c = 9; g.d = 1000;
    g.d += 23;                      /* 1023 */
    Assert(g.d == 1023, "wide (byte-crossing) bitfield +=");
    Assert(g.c == 9,    "byte-crossing bitfield op leaves neighbour c");
    g.d |= 1;
    Assert((g.d & 1) == 1, "wide bitfield |=");
}

int main(int argc, char *argv[])
{
    suite_setup("bitfield compound assignment");
    suite_add_test(test_bf_compound_or);
    suite_add_test(test_bf_compound_after_neighbour);
    suite_add_test(test_bf_compound_ops);
    suite_add_test(test_bf_compound_wide);
    return suite_run();
}
