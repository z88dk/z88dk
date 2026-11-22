/* [cmp-k-signed] Signed word compare against a constant, branch-fused, read in
 * place byte-wise through A. Every constant is checked against the long
 * compare (a different code path) at values on both sides of it, across the
 * byte and sign boundaries, for `<` and `>=`. */
#include "test.h"

static int lt0(int x) { if (x < 1) return 1; return 0; }
static int ge0(int x) { if (x >= 1) return 1; return 0; }
static int lt1(int x) { if (x < 2) return 1; return 0; }
static int ge1(int x) { if (x >= 2) return 1; return 0; }
static int lt2(int x) { if (x < 20) return 1; return 0; }
static int ge2(int x) { if (x >= 20) return 1; return 0; }
static int lt3(int x) { if (x < 127) return 1; return 0; }
static int ge3(int x) { if (x >= 127) return 1; return 0; }
static int lt4(int x) { if (x < 128) return 1; return 0; }
static int ge4(int x) { if (x >= 128) return 1; return 0; }
static int lt5(int x) { if (x < 255) return 1; return 0; }
static int ge5(int x) { if (x >= 255) return 1; return 0; }
static int lt6(int x) { if (x < 256) return 1; return 0; }
static int ge6(int x) { if (x >= 256) return 1; return 0; }
static int lt7(int x) { if (x < 257) return 1; return 0; }
static int ge7(int x) { if (x >= 257) return 1; return 0; }
static int lt8(int x) { if (x < 1000) return 1; return 0; }
static int ge8(int x) { if (x >= 1000) return 1; return 0; }
static int lt9(int x) { if (x < 4096) return 1; return 0; }
static int ge9(int x) { if (x >= 4096) return 1; return 0; }
static int lt10(int x) { if (x < 32767) return 1; return 0; }
static int ge10(int x) { if (x >= 32767) return 1; return 0; }
static int lt11(int x) { if (x < -1) return 1; return 0; }
static int ge11(int x) { if (x >= -1) return 1; return 0; }
static int lt12(int x) { if (x < -2) return 1; return 0; }
static int ge12(int x) { if (x >= -2) return 1; return 0; }
static int lt13(int x) { if (x < -20) return 1; return 0; }
static int ge13(int x) { if (x >= -20) return 1; return 0; }
static int lt14(int x) { if (x < -128) return 1; return 0; }
static int ge14(int x) { if (x >= -128) return 1; return 0; }
static int lt15(int x) { if (x < -129) return 1; return 0; }
static int ge15(int x) { if (x >= -129) return 1; return 0; }
static int lt16(int x) { if (x < -255) return 1; return 0; }
static int ge16(int x) { if (x >= -255) return 1; return 0; }
static int lt17(int x) { if (x < -256) return 1; return 0; }
static int ge17(int x) { if (x >= -256) return 1; return 0; }
static int lt18(int x) { if (x < -257) return 1; return 0; }
static int ge18(int x) { if (x >= -257) return 1; return 0; }
static int lt19(int x) { if (x < -1000) return 1; return 0; }
static int ge19(int x) { if (x >= -1000) return 1; return 0; }
static int lt20(int x) { if (x < -4096) return 1; return 0; }
static int ge20(int x) { if (x >= -4096) return 1; return 0; }
static int lt21(int x) { if (x < -32767) return 1; return 0; }
static int ge21(int x) { if (x >= -32767) return 1; return 0; }
static int lt22(int x) { if (x < -32768) return 1; return 0; }
static int ge22(int x) { if (x >= -32768) return 1; return 0; }
static int lt23(int x) { if (x < 32512) return 1; return 0; }
static int ge23(int x) { if (x >= 32512) return 1; return 0; }
static int lt24(int x) { if (x < 256) return 1; return 0; }
static int ge24(int x) { if (x >= 256) return 1; return 0; }
static int lt25(int x) { if (x < -32512) return 1; return 0; }
static int ge25(int x) { if (x >= -32512) return 1; return 0; }

static const int vals[] = { -32768,-32767,-257,-256,-255,-129,-128,-127,-2,-1,0,1,2,19,20,21,126,127,128,129,254,255,256,257,1023,1024,4095,4096,4097,32512,32767 };
#define NV ((int)(sizeof vals / sizeof vals[0]))

static int bad;
#define CHK(i, K) do { int j; for (j = 0; j < NV; j++) { \
    int x = vals[j]; \
    if (lt##i(x) != ((long)x < (long)(K)))  bad++; \
    if (ge##i(x) != ((long)x >= (long)(K))) bad++; } } while (0)

/* a loop bound on a signed counter that starts from a parameter */
static int count_up(int start) { int n = 0, i = start; while (i < 20) { n++; i++; } return n; }
static int count_dn(int start) { int n = 0, i = start; while (i >= -3) { n++; i--; if (n > 100) break; } return n; }

static void test_cmpks(void)
{
    CHK(0, 1);
    CHK(1, 2);
    CHK(2, 20);
    CHK(3, 127);
    CHK(4, 128);
    CHK(5, 255);
    CHK(6, 256);
    CHK(7, 257);
    CHK(8, 1000);
    CHK(9, 4096);
    CHK(10, 32767);
    CHK(11, -1);
    CHK(12, -2);
    CHK(13, -20);
    CHK(14, -128);
    CHK(15, -129);
    CHK(16, -255);
    CHK(17, -256);
    CHK(18, -257);
    CHK(19, -1000);
    CHK(20, -4096);
    CHK(21, -32767);
    CHK(22, -32768);
    CHK(23, 32512);
    CHK(24, 256);
    CHK(25, -32512);
    assertEqual(bad, 0);
    assertEqual(count_up(-5), 25U);
    assertEqual(count_up(19), 1U);
    assertEqual(count_up(20), 0U);
    assertEqual(count_dn(2), 6U);
}

int suite_cmpks(void) { suite_setup("signed cmp k"); suite_add_test(test_cmpks); return suite_run(); }
int main(void) { return suite_cmpks(); }
