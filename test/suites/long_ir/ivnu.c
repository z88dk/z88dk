/* [iv-narrow-unsigned] A loop counter narrowed to a byte is compared with an
 * unsigned `cp K`. Bounds either side of 127/128 and at 254/255 must still
 * count exactly, and the counter's final value must survive the loop. */
#include "test.h"

static unsigned int arr[260];

static unsigned int ult1(void) { unsigned int s = 0; int i; for (i = 0; i < 1; i++) s += (unsigned int)i; return s; }
static unsigned int ult10(void) { unsigned int s = 0; int i; for (i = 0; i < 10; i++) s += (unsigned int)i; return s; }
static unsigned int ult100(void) { unsigned int s = 0; int i; for (i = 0; i < 100; i++) s += (unsigned int)i; return s; }
static unsigned int ult127(void) { unsigned int s = 0; int i; for (i = 0; i < 127; i++) s += (unsigned int)i; return s; }
static unsigned int ult128(void) { unsigned int s = 0; int i; for (i = 0; i < 128; i++) s += (unsigned int)i; return s; }
static unsigned int ult129(void) { unsigned int s = 0; int i; for (i = 0; i < 129; i++) s += (unsigned int)i; return s; }
static unsigned int ult200(void) { unsigned int s = 0; int i; for (i = 0; i < 200; i++) s += (unsigned int)i; return s; }
static unsigned int ult254(void) { unsigned int s = 0; int i; for (i = 0; i < 254; i++) s += (unsigned int)i; return s; }
static unsigned int ult255(void) { unsigned int s = 0; int i; for (i = 0; i < 255; i++) s += (unsigned int)i; return s; }
static unsigned int ule1(void) { unsigned int s = 0; int i; for (i = 0; i <= 1; i++) s += (unsigned int)i; return s; }
static unsigned int ule10(void) { unsigned int s = 0; int i; for (i = 0; i <= 10; i++) s += (unsigned int)i; return s; }
static unsigned int ule100(void) { unsigned int s = 0; int i; for (i = 0; i <= 100; i++) s += (unsigned int)i; return s; }
static unsigned int ule126(void) { unsigned int s = 0; int i; for (i = 0; i <= 126; i++) s += (unsigned int)i; return s; }
static unsigned int ule127(void) { unsigned int s = 0; int i; for (i = 0; i <= 127; i++) s += (unsigned int)i; return s; }
static unsigned int ule128(void) { unsigned int s = 0; int i; for (i = 0; i <= 128; i++) s += (unsigned int)i; return s; }
static unsigned int ule200(void) { unsigned int s = 0; int i; for (i = 0; i <= 200; i++) s += (unsigned int)i; return s; }
static unsigned int ule253(void) { unsigned int s = 0; int i; for (i = 0; i <= 253; i++) s += (unsigned int)i; return s; }
static unsigned int ule254(void) { unsigned int s = 0; int i; for (i = 0; i <= 254; i++) s += (unsigned int)i; return s; }
static unsigned int dgt1(void) { unsigned int s = 0; int i; for (i = 1; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge1(void) { unsigned int s = 0; int i; for (i = 1; i >= 1; i--) s += 3u; return s; }
static unsigned int dgt10(void) { unsigned int s = 0; int i; for (i = 10; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge10(void) { unsigned int s = 0; int i; for (i = 10; i >= 1; i--) s += 3u; return s; }
static unsigned int dgt100(void) { unsigned int s = 0; int i; for (i = 100; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge100(void) { unsigned int s = 0; int i; for (i = 100; i >= 1; i--) s += 3u; return s; }
static unsigned int dgt127(void) { unsigned int s = 0; int i; for (i = 127; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge127(void) { unsigned int s = 0; int i; for (i = 127; i >= 1; i--) s += 3u; return s; }
static unsigned int dgt128(void) { unsigned int s = 0; int i; for (i = 128; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge128(void) { unsigned int s = 0; int i; for (i = 128; i >= 1; i--) s += 3u; return s; }
static unsigned int dgt200(void) { unsigned int s = 0; int i; for (i = 200; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge200(void) { unsigned int s = 0; int i; for (i = 200; i >= 1; i--) s += 3u; return s; }
static unsigned int dgt255(void) { unsigned int s = 0; int i; for (i = 255; i > 0; i--) s += (unsigned int)i; return s; }
static unsigned int dge255(void) { unsigned int s = 0; int i; for (i = 255; i >= 1; i--) s += 3u; return s; }

/* the counter is read after the loop */
static int after(void) { int i; for (i = 0; i < 100; i++) { arr[i] = (unsigned int)i; } return i; }

static void test_ivnu(void)
{
    assertEqual(ult1(), 0U);
    assertEqual(ult10(), 45U);
    assertEqual(ult100(), 4950U);
    assertEqual(ult127(), 8001U);
    assertEqual(ult128(), 8128U);
    assertEqual(ult129(), 8256U);
    assertEqual(ult200(), 19900U);
    assertEqual(ult254(), 32131U);
    assertEqual(ult255(), 32385U);
    assertEqual(ule1(), 1U);
    assertEqual(ule10(), 55U);
    assertEqual(ule100(), 5050U);
    assertEqual(ule126(), 8001U);
    assertEqual(ule127(), 8128U);
    assertEqual(ule128(), 8256U);
    assertEqual(ule200(), 20100U);
    assertEqual(ule253(), 32131U);
    assertEqual(ule254(), 32385U);
    assertEqual(dgt1(), 1U);
    assertEqual(dge1(), 3U);
    assertEqual(dgt10(), 55U);
    assertEqual(dge10(), 30U);
    assertEqual(dgt100(), 5050U);
    assertEqual(dge100(), 300U);
    assertEqual(dgt127(), 8128U);
    assertEqual(dge127(), 381U);
    assertEqual(dgt128(), 8256U);
    assertEqual(dge128(), 384U);
    assertEqual(dgt200(), 20100U);
    assertEqual(dge200(), 600U);
    assertEqual(dgt255(), 32640U);
    assertEqual(dge255(), 765U);
    assertEqual(after(), 100);
}

int suite_ivnu(void) { suite_setup("iv narrow unsigned"); suite_add_test(test_ivnu); return suite_run(); }
int main(void) { return suite_ivnu(); }
