/* byte-remat: single-use global byte loads rematerialised at their use instead
   of slotted. Exercises the binop-consumer paths (remat) AND the RET / hazard
   paths (must NOT remat — regression guard for the ix-slot-garbage miscompile).
   [IR_CALL_BREMAT] adds the CALL-ARGUMENT consumer (the emu.c effective_string
   shape, `return f(p, g_base, g_num)`): a byte argument is read once by the
   marshaller and pushed, so the load is re-issued at the push site. The cases
   below pin every argument path (stacked, fastcall) and the two shapes that must
   NOT remat (a call between the load and its use; a second use). */
#include "test.h"
typedef unsigned char u8;
u8 g1, g2;
static u8 or2(void)    { return g1 | g2; }      /* OR  -> remat both  */
static u8 and_c(void)  { return g1 & 0x0f; }    /* AND const -> remat */
static u8 xor2(void)   { return g1 ^ g2; }      /* XOR -> remat both  */
static u8 ret_g(void)  { return g2; }           /* bare RET -> must NOT remat */
static u8 hazard(void) { u8 a = g1; g1 = 0x99; return a; } /* write between -> no remat */

/* Stacked byte args (smallc, widened to words at the push): both globals are
   single-use terminal consumers -> both remat at their own push site. */
static unsigned int mix3(unsigned int a, u8 b, u8 c)
{
    return (unsigned int)(a + (unsigned int)b * 256u + c);
}
static unsigned int call_args(unsigned int a) { return mix3(a, g1, g2); }

/* Fastcall byte arg: read through load_byte_to_a. */
static u8 twice(u8 x) __z88dk_fastcall { return (u8)(x + x); }
static u8 call_fc(void) { return twice(g2); }

/* A CALL between the load and its use is a memory-write hazard: the captured
   value must be the OLD g1, so this one keeps its slot. */
static u8 bumps;
static void bump(void) { g1 = (u8)(g1 + 1u); bumps++; }
static unsigned int call_hazard(unsigned int a)
{
    u8 v = g1;
    bump();
    return mix3(a, v, g2);
}

/* Two uses (argument AND arithmetic afterwards) -> not single-use, no remat. */
static unsigned int call_twouse(unsigned int a)
{
    u8 v = g2;
    return (unsigned int)(mix3(a, g1, v) + v);
}

static void run(void)
{
    g1 = 0xAC; g2 = 0x53;
    Assert(or2()   == (u8)(0xAC | 0x53), "or2");
    Assert(and_c() == (u8)(0xAC & 0x0f), "and_c");
    Assert(xor2()  == (u8)(0xAC ^ 0x53), "xor2");
    Assert(ret_g() == 0x53, "ret_g");
    g1 = 0xAC;
    Assert(hazard() == 0xAC, "hazard keeps old g1");
    Assert(g1 == 0x99, "hazard wrote g1");

    g1 = 0x12; g2 = 0x34; bumps = 0;
    Assert(call_args(0x0100u) == (unsigned int)(0x0100u + 0x1200u + 0x34u),
           "call_args");
    Assert(call_fc() == (u8)(0x34 + 0x34), "call_fc");
    Assert(call_twouse(0x0100u)
           == (unsigned int)(0x0100u + 0x1200u + 0x34u + 0x34u), "call_twouse");

    /* g1 reads 0x12 into v, bump() makes it 0x13; the arg must still be 0x12. */
    Assert(call_hazard(0x0100u) == (unsigned int)(0x0100u + 0x1200u + 0x34u),
           "call_hazard uses the pre-call g1");
    Assert(g1 == 0x13, "call_hazard's bump wrote g1");
    Assert(bumps == 1, "bump ran once");
}
int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte-remat");
    suite_add_test(run);
    return suite_run();
}
