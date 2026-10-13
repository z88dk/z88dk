/* --opt-code-size: a four-byte load through a computed pointer is
 * `call l_glong`. The value, the register state after it and a following
 * load must match the inline sequence. */
#include "test.h"

static long   la[8];
static unsigned long ula[8];
static float  fa[8];
static long   lg2[4][3];
static struct { int a; long b; float c; } sa[4];
static volatile int sink;

static long   pick_l(int i)            { return la[i]; }
static long   sum_l(int i, int j)      { return la[i] + la[j]; }
static long   xor_l(int i, int j)      { return la[i] ^ ula[j]; }
static long   mid_l(int i, int j)      { return lg2[i][j]; }
static long   st_b(int i)              { return sa[i].b; }
static float  st_c(int i)              { return sa[i].c; }
static float  fsum(int i, int j)       { return fa[i] + fa[j] * 2; }
static long   two_loads(int i)         { long t = la[i]; sink++; return t + la[i + 1]; }
static int    cmp_l(int i, int j)      { return la[i] < la[j]; }
static void   copy_l(int i, int j)     { la[i] = la[j]; }
static long   add_arg(long x, long y)  { return x + y; }
static long   call_l(int i, int j)     { return add_arg(la[i], la[j]); }

static void test_sizeglong(void)
{
    int i, j;
    for (i = 0; i < 8; i++) { la[i] = (long)i * 70001L - 100000L; ula[i] = 0xA5A5A5A5UL + i; fa[i] = (float)i + 0.5f; }
    for (i = 0; i < 4; i++) { for (j = 0; j < 3; j++) lg2[i][j] = (long)(i * 3 + j) * 99991L + 7; sa[i].a = i; sa[i].b = 123456L * (i + 1) - 7; sa[i].c = (float)(i * 3); }
    for (i = 0; i < 8; i++) assertEqual(pick_l(i) == (long)i * 70001L - 100000L, 1);
    assertEqual(sum_l(2, 5) == la[2] + la[5], 1);
    assertEqual(xor_l(3, 4) == (la[3] ^ ula[4]), 1);
    for (i = 0; i < 4; i++) for (j = 0; j < 3; j++) assertEqual(mid_l(i, j) == (long)(i * 3 + j) * 99991L + 7, 1);
    for (i = 0; i < 4; i++) { assertEqual(st_b(i) == 123456L * (i + 1) - 7, 1); assertEqual((int)st_c(i), i * 3); }
    assertEqual((int)fsum(1, 2), 6);
    assertEqual(two_loads(3) == la[3] + la[4], 1);
    assertEqual(cmp_l(1, 6), 1); assertEqual(cmp_l(6, 1), 0);
    copy_l(0, 7); assertEqual(la[0] == la[7], 1);
    assertEqual(call_l(2, 6) == la[2] + la[6], 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("size-mode four-byte loads");
    suite_add_test(test_sizeglong);
    return suite_run();
}
