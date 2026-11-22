/* Unsigned width-2 bound compare against a constant whose LOW BYTE IS ZERO.
 *
 * For K = H*256 and i = ih*256 + il, `i < K` is exactly `ih < H`:
 *
 *     ih <  H  ->  i <= ih*256+255 < (ih+1)*256 <= K   so i < K
 *     ih == H  ->  i  = H*256 + il >= K                so not i < K
 *     ih >  H  ->  i > K
 *
 * so the lowerer compares the HIGH BYTES only (`ld a,h; cp H`) instead of the
 * 16-bit `ld hl,src; ld de,K; and a; sbc hl,de`. The dangerous part is not the
 * algebra, it is the BRANCH POLARITY: `<` is true on carry and `>=` is true on
 * no-carry, and inverting one silently reverses a loop bound.
 *
 * Every case is tested at the three points that separate the forms:
 *   K-1  (largest value below the bound, low byte 0xff)
 *   K    (the bound itself, the equality case the narrowing must get right)
 *   K+1  (just above)
 * plus 0 and 0xffff. A high-byte-only compare that mishandles equality passes
 * K-1 and fails K, so these pin it.
 *
 * `lt` and `ge` cover both polarities. `loop_bound` is the shape that motivated
 * it -- rle_encode's `while (i < N)` with N = 1024, where the compare runs
 * every inner iteration. `odd_bound` uses a constant whose low byte is NOT
 * zero, so the narrowing must NOT fire and the ordinary path must still be
 * right.
 *
 * Values come through a function so they stay runtime operands. Self-verifying,
 * no printf.
 */
#include "test.h"

typedef unsigned int u16;

/* Written as a BRANCH, not as a materialised bool: the narrowing only fires
   when the compare is branch-fused, so `return (u16)(i < K)` would exercise
   the ordinary path and prove nothing about this change. */
static u16 lt_1024(u16 i) { if (i < 1024u)   return 1u; return 0u; }
static u16 ge_1024(u16 i) { if (i >= 1024u)  return 1u; return 0u; }
static u16 lt_256 (u16 i) { if (i < 256u)    return 1u; return 0u; }
static u16 ge_256 (u16 i) { if (i >= 256u)   return 1u; return 0u; }
static u16 lt_ff00(u16 i) { if (i < 0xff00u) return 1u; return 0u; }
static u16 ge_ff00(u16 i) { if (i >= 0xff00u) return 1u; return 0u; }

/* Low byte is not zero: the narrowing must not fire. */
static u16 lt_1000(u16 i) { if (i < 1000u)   return 1u; return 0u; }
static u16 ge_1000(u16 i) { if (i >= 1000u)  return 1u; return 0u; }

/* The rle_encode shape: the bound compare drives the loop. */
static u16 loop_bound(u16 start)
{
    u16 i = start, n = 0;
    while (i < 1024u) { n++; i++; }
    return n;
}

static void test_cmphi(void)
{
    Assert(lt_1024(0x0000u) == 1u, "lt_1024 0x0000");
    Assert(lt_1024(0x03FFu) == 1u, "lt_1024 0x03FF");
    Assert(lt_1024(0x0400u) == 0u, "lt_1024 0x0400");
    Assert(lt_1024(0x0401u) == 0u, "lt_1024 0x0401");
    Assert(lt_1024(0xFFFFu) == 0u, "lt_1024 0xFFFF");
    Assert(ge_1024(0x0000u) == 0u, "ge_1024 0x0000");
    Assert(ge_1024(0x03FFu) == 0u, "ge_1024 0x03FF");
    Assert(ge_1024(0x0400u) == 1u, "ge_1024 0x0400");
    Assert(ge_1024(0x0401u) == 1u, "ge_1024 0x0401");
    Assert(ge_1024(0xFFFFu) == 1u, "ge_1024 0xFFFF");

    Assert(lt_256(0x0000u) == 1u, "lt_256 0x0000");
    Assert(lt_256(0x00FFu) == 1u, "lt_256 0x00FF");
    Assert(lt_256(0x0100u) == 0u, "lt_256 0x0100");
    Assert(lt_256(0x0101u) == 0u, "lt_256 0x0101");
    Assert(lt_256(0xFFFFu) == 0u, "lt_256 0xFFFF");
    Assert(ge_256(0x0000u) == 0u, "ge_256 0x0000");
    Assert(ge_256(0x00FFu) == 0u, "ge_256 0x00FF");
    Assert(ge_256(0x0100u) == 1u, "ge_256 0x0100");
    Assert(ge_256(0x0101u) == 1u, "ge_256 0x0101");
    Assert(ge_256(0xFFFFu) == 1u, "ge_256 0xFFFF");

    Assert(lt_ff00(0x0000u) == 1u, "lt_ff00 0x0000");
    Assert(lt_ff00(0xFEFFu) == 1u, "lt_ff00 0xFEFF");
    Assert(lt_ff00(0xFF00u) == 0u, "lt_ff00 0xFF00");
    Assert(lt_ff00(0xFF01u) == 0u, "lt_ff00 0xFF01");
    Assert(lt_ff00(0xFFFFu) == 0u, "lt_ff00 0xFFFF");
    Assert(ge_ff00(0x0000u) == 0u, "ge_ff00 0x0000");
    Assert(ge_ff00(0xFEFFu) == 0u, "ge_ff00 0xFEFF");
    Assert(ge_ff00(0xFF00u) == 1u, "ge_ff00 0xFF00");
    Assert(ge_ff00(0xFF01u) == 1u, "ge_ff00 0xFF01");
    Assert(ge_ff00(0xFFFFu) == 1u, "ge_ff00 0xFFFF");

    Assert(lt_1000(0x0000u) == 1u, "lt_1000 0x0000");
    Assert(lt_1000(0x03E7u) == 1u, "lt_1000 0x03E7");
    Assert(lt_1000(0x03E8u) == 0u, "lt_1000 0x03E8");
    Assert(lt_1000(0x03E9u) == 0u, "lt_1000 0x03E9");
    Assert(lt_1000(0xFFFFu) == 0u, "lt_1000 0xFFFF");
    Assert(ge_1000(0x0000u) == 0u, "ge_1000 0x0000");
    Assert(ge_1000(0x03E7u) == 0u, "ge_1000 0x03E7");
    Assert(ge_1000(0x03E8u) == 1u, "ge_1000 0x03E8");
    Assert(ge_1000(0x03E9u) == 1u, "ge_1000 0x03E9");
    Assert(ge_1000(0xFFFFu) == 1u, "ge_1000 0xFFFF");

    Assert(loop_bound(0x0000u) == 1024u, "loop_bound 0");
    Assert(loop_bound(0x03E8u) == 24u, "loop_bound 1000");
    Assert(loop_bound(0x03FFu) == 1u, "loop_bound 1023");
    Assert(loop_bound(0x0400u) == 0u, "loop_bound 1024");
    Assert(loop_bound(0x07D0u) == 0u, "loop_bound 2000");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Unsigned bound compare narrowed to the high byte");
    suite_add_test(test_cmphi);
    return suite_run();
}
