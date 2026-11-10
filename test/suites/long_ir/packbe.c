/* Big-endian and little-endian reads assembled from bytes, plus orderings that
 * look similar but must not become one load. The reference multiplies by
 * volatile constants, so it never takes the shift-and-or shape.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

static u8 buf[24] = { 0x00, 0x80, 0xff, 0x01, 0x7f, 0x10, 0xa5, 0x5a,
                      0x00, 0x00, 0xff, 0xff, 0x12, 0x34, 0x56, 0x78,
                      0x9a, 0xbc, 0xde, 0xf0, 0x81, 0x02, 0x40, 0xc3 };
volatile u32 k24 = 16777216UL, k16 = 65536UL, k8 = 256UL, k1 = 1UL;
volatile u16 j8 = 256;

static u32 be32(const u8 *p) { return ((u32)p[0]<<24)|((u32)p[1]<<16)|((u32)p[2]<<8)|p[3]; }
static u32 be32o(const u8 *p) { return ((u32)p[2]<<24)|((u32)p[3]<<16)|((u32)p[4]<<8)|p[5]; }
static u32 le32(const u8 *p) { return p[0]|((u32)p[1]<<8)|((u32)p[2]<<16)|((u32)p[3]<<24); }
static u16 be16(const u8 *p) { return (u16)(((u16)p[0]<<8)|p[1]); }
static u32 gbe32(void) { return ((u32)buf[4]<<24)|((u32)buf[5]<<16)|((u32)buf[6]<<8)|buf[7]; }
/* Not a plain big- or little-endian read: lanes swapped or repeated. */
static u32 mix1(const u8 *p) { return ((u32)p[1]<<24)|((u32)p[0]<<16)|((u32)p[3]<<8)|p[2]; }
static u32 mix2(const u8 *p) { return ((u32)p[0]<<24)|((u32)p[1]<<16)|((u32)p[2]<<8)|p[2]; }
static u32 mix3(const u8 *p) { return ((u32)p[0]<<24)|((u32)p[0]<<16)|((u32)p[1]<<8)|p[1]; }
/* A store between the loads: the second read must see the new byte. */
static u32 be32w(u8 *p) { u32 a = (u32)p[0]<<24; p[2] = 0x3c; return a|((u32)p[1]<<16)|((u32)p[2]<<8)|p[3]; }

static u32 ref(u8 a, u8 b, u8 c, u8 d) { return a*k24 + b*k16 + c*k8 + d*k1; }

static void check(void)
{
    int bad = 0, i;
    u8 tmp[8];
    for (i = 0; i < 18; ++i) {
        const u8 *p = buf + i;
        if (be32(p)  != ref(p[0], p[1], p[2], p[3])) ++bad;
        if (le32(p)  != ref(p[3], p[2], p[1], p[0])) ++bad;
        if (be32o(p) != ref(p[2], p[3], p[4], p[5])) ++bad;
        if (be16(p)  != (u16)(p[0]*j8 + p[1])) ++bad;
        if (mix1(p)  != ref(p[1], p[0], p[3], p[2])) ++bad;
        if (mix2(p)  != ref(p[0], p[1], p[2], p[2])) ++bad;
        if (mix3(p)  != ref(p[0], p[0], p[1], p[1])) ++bad;
    }
    if (gbe32() != ref(buf[4], buf[5], buf[6], buf[7])) ++bad;
    for (i = 0; i < 8; ++i) tmp[i] = buf[i + 3];
    if (be32w(tmp) != ref(buf[3], buf[4], 0x3c, buf[6])) ++bad;
    assertEqual(bad, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("big-endian byte reads");
    suite_add_test(check);
    return suite_run();
}
