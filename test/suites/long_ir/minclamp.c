/* A long select narrowed to a word, a long difference shared by a compare
 * and the select arm, and a signed or unsigned char compared with a negative
 * constant. */
#include "test.h"

#define min(a, b) ((a) < (b) ? (a) : (b))

signed char sg;
unsigned char ug;
unsigned out[8];

static unsigned clamp8(long k, long n)       { return (unsigned)min(k - n, (long)8); }
static unsigned clampg(long k, long n)       { unsigned m = (unsigned)min(k - n, 8L); return m + 1; }
static unsigned clampsel(long k, long n, long a) { return (unsigned)(k < n ? a : k - n); }
static long wide(long k, long n)             { return min(k - n, 8L); }
static int sg_m1(void)                       { return sg == -1; }
static int sg_nm1(void)                      { return sg != -1; }
static int sg_m128(void)                     { return sg == -128; }
static int sgp_m1(signed char c)             { if (c == -1) return 10; return 20; }
static int ug_m1(void)                       { return ug == -1; }
static int ug_255(void)                      { return ug == 255; }

static void walk(void)
{
    long n = 0, k = 21;
    unsigned m, sum = 0;
    int i = 0;

    while (n < k) {
        m = (unsigned)min(k - n, (long)8);
        out[i++] = m;
        sum += m;
        n += m;
    }
    assertEqual(i, 3);
    assertEqual(out[0], 8);
    assertEqual(out[1], 8);
    assertEqual(out[2], 5);
    assertEqual(sum, 21);
}

static void clamp(void)
{
    assertEqual(clamp8(100L, 0L), 8);
    assertEqual(clamp8(100L, 92L), 8);
    assertEqual(clamp8(100L, 93L), 7);
    assertEqual(clamp8(100000L, 99995L), 5);
    assertEqual(clamp8(70000L, 0L), 8);
    assertEqual(clamp8(0L, 70000L), (unsigned)(-70000L));
    assertEqual(clamp8(5L, 5L), 0);
    assertEqual(clampg(10L, 5L), 6);
    assertEqual(clampg(100L, 5L), 9);
    assertEqual(clampsel(5L, 9L, 77L), 77);
    assertEqual(clampsel(9L, 5L, 77L), 4);
    assertEqual(clampsel(70005L, 5L, 77L), (unsigned)70000L);
    assertEqual(wide(100000L, 0L) == 8L, 1);
    assertEqual(wide(100000L, 99999L) == 1L, 1);
}

static void bytecmp(void)
{
    int i;
    signed char vals[5] = { -1, 0, 127, -128, 1 };

    for (i = 0; i < 5; i++) {
        sg = vals[i];
        assertEqual(sg_m1(), vals[i] == -1);
        assertEqual(sg_nm1(), vals[i] != -1);
        assertEqual(sg_m128(), vals[i] == -128);
        assertEqual(sgp_m1(vals[i]), vals[i] == -1 ? 10 : 20);
    }
    ug = 255;
    assertEqual(ug_m1(), 0);
    assertEqual(ug_255(), 1);
    ug = 1;
    assertEqual(ug_m1(), 0);
    assertEqual(ug_255(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long select narrowing, shared difference, negative byte compare");
    suite_add_test(walk);
    suite_add_test(clamp);
    suite_add_test(bytecmp);
    return suite_run();
}
