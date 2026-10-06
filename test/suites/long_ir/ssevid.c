/* [ss-evidence] Lazy spill drops a spill store when no later use reads its
 * slot. A use whose register serve no hook proved now also counts as served
 * when nothing in its op touched the slot. The emu.c do_add shapes drop their
 * stores; the values read after a branch or across a loop keep them. */
#include "test.h"
#include <intrinsic.h>

typedef unsigned char type8;
typedef signed char type8s;
typedef unsigned long type32;

#define read_l(p)     (intrinsic_swap_endian_32(*(type32 *)(p)))
#define write_l(p, v) (*(type32 *)(p) = intrinsic_swap_endian_32(v))

static type8 b1[4], b2[4];
static type8 *arg1, *arg2;
static int sink;

static void add_b(void)
{
    write_l(arg1, read_l(arg1) + (type8s)arg2[0]);
}

static void add_l(void)
{
    write_l(arg1, read_l(arg1) + read_l(arg2));
}

static void note(int v) { sink += v; }

/* The sum is read again after a call and in the other arm. */
static long keep_branch(long a, long b, int c)
{
    long s = a + b;
    note(c);
    if (c > 2)
        return s - 1;
    return s + (long)c;
}

/* The running total is read on the next trip. */
static long keep_loop(long a, int n)
{
    long t = a;
    int i;
    for (i = 0; i < n; i++) {
        t = t + (long)i * 3;
        note(i);
    }
    return t;
}

/* sccz80/loops.c loop16: the truncated counter's store is dropped, and the
   increment, done in place on the long counter's slot, must not trust a long
   cache whose low half BC then holds the element address. */
static unsigned char arr[300];
static void loop16(unsigned char *a)
{
    for (unsigned long i = 0; i < 300; i++)
        a[i] = 16;
}

static void test_ssevid(void)
{
    b1[0] = 0x12; b1[1] = 0x34; b1[2] = 0x56; b1[3] = 0x78;
    b2[0] = 0xff; b2[1] = 0x00; b2[2] = 0x00; b2[3] = 0x01;
    arg1 = b1; arg2 = b2;
    add_b();                                   /* 0x12345678 + (-1) */
    assertEqual(b1[3], 0x77);
    assertEqual(b1[2], 0x56);
    add_l();                                   /* + 0xff000001 */
    assertEqual(b1[0], 0x11);
    assertEqual(b1[1], 0x34);
    assertEqual(b1[2], 0x56);
    assertEqual(b1[3], 0x78);
    sink = 0;
    assertEqual((int)keep_branch(70000L, 5L, 2), 4471);
    assertEqual((int)(keep_branch(70000L, 5L, 2) >> 16), 1);
    assertEqual((int)keep_branch(70000L, 5L, 9), 4468);
    assertEqual((int)keep_loop(100000L, 10), -30937);
    assertEqual(sink, 58);
    loop16(arr);
    assertEqual(arr[0], 16);
    assertEqual(arr[17], 16);
    assertEqual(arr[255], 16);
    assertEqual(arr[256], 16);
    assertEqual(arr[299], 16);
}

int main(int argc, char *argv[])
{
    suite_setup("ssevid");
    suite_add_test(test_ssevid);
    return suite_run();
}
