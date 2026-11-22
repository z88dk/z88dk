/* IR_BSWAP: intrinsic_swap_endian_16/32 and __builtin_bswap16/32 are compiler
 * operations. Register form, big-endian read and write through a pointer,
 * double reverse, constants, and values that stay live across other work. */
#include "test.h"
#include <intrinsic.h>

typedef unsigned long u32;
typedef unsigned int  u16;

static unsigned char buf[24];
static u32 gl;
static volatile int sink;

static u32  sw32(u32 x)                 { return intrinsic_swap_endian_32(x); }
static u16  sw16(u16 x)                 { return intrinsic_swap_endian_16(x); }
static u32  bs32(u32 x)                 { return __builtin_bswap32(x); }
static u16  bs16(u16 x)                 { return __builtin_bswap16(x); }
static u32  rd32(unsigned char *p)      { return intrinsic_swap_endian_32(*(u32 *)p); }
static u16  rd16(unsigned char *p)      { return intrinsic_swap_endian_16(*(u16 *)p); }
static void wr32(unsigned char *p, u32 v) { *(u32 *)p = intrinsic_swap_endian_32(v); }
static void wr16(unsigned char *p, u16 v) { *(u16 *)p = intrinsic_swap_endian_16(v); }
static u32  twice(u32 x)                { return intrinsic_swap_endian_32(intrinsic_swap_endian_32(x)); }
static u32  konst(void)                 { return intrinsic_swap_endian_32(0x11223344UL); }
static u32  add_be(unsigned char *p, unsigned char *q) { return rd32(p) + rd32(q); }
static u32  live(u32 x, u32 y)          { u32 a = intrinsic_swap_endian_32(x); sink++; return a ^ y; }
static void glob(u32 x)                 { gl = intrinsic_swap_endian_32(x); }
static u32  rdglob(void)                { return intrinsic_swap_endian_32(gl); }
static u32  cmpmix(u32 x, u32 y)        { return intrinsic_swap_endian_32(x) < intrinsic_swap_endian_32(y); }
static u32  loop_sum(unsigned char *p, int n) { u32 s = 0; int i; for (i = 0; i < n; i++) s += rd32(p + 4 * i); return s; }

static void test_bswap(void)
{
    int i;
    assertEqual(sw32(0x12345678UL) == 0x78563412UL, 1);
    assertEqual(sw32(0xA1B2C3D4UL) == 0xD4C3B2A1UL, 1);
    assertEqual(sw32(0UL) == 0UL, 1);
    assertEqual(sw32(0xFFFFFFFFUL) == 0xFFFFFFFFUL, 1);
    assertEqual(sw32(1UL) == 0x01000000UL, 1);
    assertEqual(bs32(0x12345678UL) == 0x78563412UL, 1);
    assertEqual(sw16(0x1234) == 0x3412, 1);
    assertEqual(sw16(0x00FF) == 0xFF00, 1);
    assertEqual(bs16(0xA1B2) == 0xB2A1, 1);
    for (i = 0; i < 8; i++) buf[i] = (unsigned char)(0x10 * i + i + 1);
    assertEqual(rd32(buf) == 0x01122334UL, 1);
    assertEqual(rd32(buf + 4) == 0x45566778UL, 1);
    assertEqual(rd16(buf + 1) == 0x1223, 1);
    wr32(buf + 8, 0xDEADBEEFUL);
    assertEqual(buf[8] == 0xDE && buf[9] == 0xAD && buf[10] == 0xBE && buf[11] == 0xEF, 1);
    wr16(buf + 12, 0xCAFE);
    assertEqual(buf[12] == 0xCA && buf[13] == 0xFE, 1);
    assertEqual(rd32(buf + 8) == 0xDEADBEEFUL, 1);
    assertEqual(twice(0x12345678UL) == 0x12345678UL, 1);
    assertEqual(konst() == 0x44332211UL, 1);
    assertEqual(add_be(buf, buf + 4) == 0x01122334UL + 0x45566778UL, 1);
    assertEqual(live(0x12345678UL, 0xFFFF0000UL) == (0x78563412UL ^ 0xFFFF0000UL), 1);
    glob(0x01020304UL);
    assertEqual(gl == 0x04030201UL, 1);
    assertEqual(rdglob() == 0x01020304UL, 1);
    assertEqual(cmpmix(0x01000000UL, 0x00000001UL), 1);
    assertEqual(cmpmix(0x00000001UL, 0x01000000UL), 0);
    assertEqual(loop_sum(buf, 2) == 0x01122334UL + 0x45566778UL, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("bswap builtin");
    suite_add_test(test_bswap);
    return suite_run();
}
