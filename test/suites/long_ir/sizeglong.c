/* --opt-code-size: a four-byte load through a computed pointer is
 * `call l_glong`. The value, the register state after it and a following
 * load must match the inline sequence. */
#include "test.h"
#include <intrinsic.h>

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
/* A big-endian read of a long: the load and the byte reverse are fused by the
 * copt rules, so --opt-code-size leaves the load inline when a swap follows. */
static unsigned char be_buf[16];
static unsigned long be_read(unsigned char *p)           { return intrinsic_swap_endian_32(*(unsigned long *)p); }
static void          be_write(unsigned char *p, unsigned long v) { *(unsigned long *)p = intrinsic_swap_endian_32(v); }
static unsigned long be_add(unsigned char *p, unsigned char *q) { return be_read(p) + be_read(q); }
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
    be_buf[0] = 0x12; be_buf[1] = 0x34; be_buf[2] = 0x56; be_buf[3] = 0x78;
    be_buf[4] = 0x00; be_buf[5] = 0x01; be_buf[6] = 0x00; be_buf[7] = 0x02;
    Assert(be_read(be_buf) == 0x12345678UL, "big-endian read");
    Assert(be_add(be_buf, be_buf + 4) == 0x1235567AUL, "big-endian add");
    be_write(be_buf + 8, 0xA1B2C3D4UL);
    assertEqual(be_buf[8] == 0xA1 && be_buf[9] == 0xB2 && be_buf[10] == 0xC3 && be_buf[11] == 0xD4, 1);
    Assert(be_read(be_buf + 8) == 0xA1B2C3D4UL, "big-endian write then read");
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("size-mode four-byte loads");
    suite_add_test(test_sizeglong);
    return suite_run();
}
