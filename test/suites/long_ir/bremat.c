/* byte-remat: single-use global byte loads rematerialised at their use instead
   of slotted. Exercises the binop-consumer paths (remat) AND the RET / hazard
   paths (must NOT remat — regression guard for the ix-slot-garbage miscompile). */
#include "test.h"
typedef unsigned char u8;
u8 g1, g2;
static u8 or2(void)    { return g1 | g2; }      /* OR  -> remat both  */
static u8 and_c(void)  { return g1 & 0x0f; }    /* AND const -> remat */
static u8 xor2(void)   { return g1 ^ g2; }      /* XOR -> remat both  */
static u8 ret_g(void)  { return g2; }           /* bare RET -> must NOT remat */
static u8 hazard(void) { u8 a = g1; g1 = 0x99; return a; } /* write between -> no remat */

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
}
int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte-remat");
    suite_add_test(run);
    return suite_run();
}
