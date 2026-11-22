/* [IR_FCLONG_CARRY] An auto-pushed width-4 __z88dk_fastcall param arrives in
   DE:HL. The entry push materialises its frame slot but leaves the value in the
   registers, so the prologue stashes the low half in BC (the DEHL cache
   invariant) and claims the cache — the first read costs nothing instead of
   reloading the four bytes just pushed.

   emu.c's effective_string family is the shape: one line, forwarding the long
   straight into another call. The cases below pin where the carry is and is NOT
   valid; each returns a value that differs if the wrong bytes are read.

     fwd        the win: the param is the first argument of the only call.
     twice      read twice — the second read must still see the whole long.
     after_call a call runs BEFORE the read, so DE/BC are gone and the read must
                come from the slot. A stale cache returns the callee's result.
     in_branch  the read is in a later BB. The seed is entry-BB only; a later
                block must reload.
     mixed      arithmetic on the param first, then a forward of the ORIGINAL —
                the sum evicts the registers, so the forward reloads.
*/
#include "test.h"
typedef unsigned char u8;
typedef unsigned long u32;

u8 gb1, gb2;
static u32 seen;

static u32 sink3(u32 p, u8 a, u8 b)
{
    return (u32)(p + (u32)a * 0x10000ul + (u32)b);
}
static u32 bump(void) { seen = (u32)(seen + 1ul); return 0xdeadbeeful; }

static u32 fwd(u32 p) __z88dk_fastcall        { return sink3(p, gb1, gb2); }
static u32 twice(u32 p) __z88dk_fastcall      { return (u32)(sink3(p, 0, 0) + p); }
static u32 after_call(u32 p) __z88dk_fastcall { bump(); return sink3(p, 0, 0); }
static u32 in_branch(u32 p) __z88dk_fastcall
{
    if (gb1) return sink3(p, 1, 0);
    return sink3(p, 0, 1);
}
static u32 mixed(u32 p) __z88dk_fastcall
{
    u32 s = (u32)(p + 0x00010001ul);
    return (u32)(sink3(p, 0, 0) + s);
}

static void run(void)
{
    gb1 = 2; gb2 = 3; seen = 0;
    Assert(fwd(0x11223344ul) == 0x11243347ul, "fwd");
    Assert(twice(0x11223344ul) == 0x22446688ul, "twice");
    Assert(after_call(0x11223344ul) == 0x11223344ul, "after_call");
    Assert(seen == 1ul, "bump ran once");

    gb1 = 1;
    Assert(in_branch(0x11223344ul) == 0x11233344ul, "in_branch taken");
    gb1 = 0;
    Assert(in_branch(0x11223344ul) == 0x11223345ul, "in_branch fallthrough");

    Assert(mixed(0x11223344ul) == 0x22456689ul, "mixed");
}
int main(int c, char **v)
{
    (void)c; (void)v;
    suite_setup("fclong");
    suite_add_test(run);
    return suite_run();
}
