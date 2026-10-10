/* A char promoted to int, shifted by a constant and masked into a byte stays
 * a byte computation: the sign bits it drops never reach the mask. Includes
 * the base64-style regroup of three bytes with negative values.
 */
#include "test.h"

static int shl_mask(char *p)        { return (p[0] << 4) & 060; }
static int sra_mask(char *p)        { return (p[1] >> 4) & 017; }
static int sra_mask_hi(char *p)     { return (p[2] >> 6) & 03; }
static int sra_all(char *p)         { return (p[0] >> 2) & 0xff; }
static int regroup(char *p)         { return ((p[0] << 4) & 060) | ((p[1] >> 4) & 017); }
static int regroup2(char *p)        { return ((p[1] << 2) & 074) | ((p[2] >> 6) & 03); }
static int xorgroup(char *p)        { return ((p[0] << 1) & 0x7e) ^ ((p[1] >> 3) & 0x1f); }
static int widesum(char *p)         { return ((p[0] >> 4) & 15) + 1000; }

static void check(void)
{
    char a[3];
    int i, j, k;

    for (i = -128; i < 128; i += 17) {
        for (j = -128; j < 128; j += 19) {
            for (k = -128; k < 128; k += 23) {
                a[0] = (char)i; a[1] = (char)j; a[2] = (char)k;
                assertEqual(shl_mask(a), (i << 4) & 060);
                assertEqual(sra_mask(a + 0) == sra_mask(a), 1);
                assertEqual(sra_mask(a), (j >> 4) & 017);
                assertEqual(sra_mask_hi(a), (k >> 6) & 03);
                assertEqual(sra_all(a), (i >> 2) & 0xff);
                assertEqual(regroup(a), ((i << 4) & 060) | ((j >> 4) & 017));
                assertEqual(regroup2(a), ((j << 2) & 074) | ((k >> 6) & 03));
                assertEqual(xorgroup(a), ((i << 1) & 0x7e) ^ ((j >> 3) & 0x1f));
                assertEqual(widesum(a), ((i >> 4) & 15) + 1000);
            }
        }
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant shifts of chars masked into a byte");
    suite_add_test(check);
    return suite_run();
}
