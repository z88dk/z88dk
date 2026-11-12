/* Bytes of one long taken one after another: (uint8_t)v, v >> 8, v >> 16,
 * v >> 24, with values that disturb the registers between them.
 */
#include "test.h"

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;

static u8 t[8];
volatile u8 vz;

static void split(u8 *p, u32 v)
{
    p[0] = (u8)v;
    p[1] = (u8)(v >> 8);
    p[2] = (u8)(v >> 16);
    p[3] = (u8)(v >> 24);
}

/* A byte store from a computed value between the extractions. */
static void split_mid(u8 *p, u32 v, u8 k)
{
    p[0] = (u8)v;
    p[1] = (u8)(v >> 8) + k;
    p[2] = (u8)(k * 3);
    p[3] = (u8)(v >> 16);
    p[4] = (u8)(v >> 24);
}

/* The long itself is used again after its bytes. */
static u32 split_use(u8 *p, u32 v)
{
    p[0] = (u8)v;
    p[1] = (u8)(v >> 8);
    p[2] = (u8)(v >> 16);
    return v + 1;
}

static u32 vals[] = { 0, 1, 0xFF, 0x100, 0x1234, 0x10000, 0x123456, 0x12345678,
                      0xFEDCBA98, 0x80000000, 0xFFFFFFFF, 0x00FF00FF };

static void check(void)
{
    int b1 = 0, b2 = 0, b3 = 0;
    unsigned i;
    for (i = 0; i < sizeof vals / sizeof vals[0]; ++i) {
        u32 v = vals[i];
        u8 k = (u8)(i * 7 + vz);
        split(t, v);
        if (t[0] != (u8)v || t[1] != (u8)(v >> 8) || t[2] != (u8)(v >> 16)
            || t[3] != (u8)(v >> 24)) ++b1;
        split_mid(t, v, k);
        if (t[0] != (u8)v || t[1] != (u8)((u8)(v >> 8) + k) || t[2] != (u8)(k * 3)
            || t[3] != (u8)(v >> 16) || t[4] != (u8)(v >> 24)) ++b2;
        if (split_use(t, v) != v + 1) ++b3;
        if (t[0] != (u8)v || t[1] != (u8)(v >> 8) || t[2] != (u8)(v >> 16)) ++b3;
    }
    assertEqual(b1, 0);
    assertEqual(b2, 0);
    assertEqual(b3, 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("bytes of one long");
    suite_add_test(check);
    return suite_run();
}
