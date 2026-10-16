/* A 16-bit byte swap fused with the word load or store next to it, a bitwise
 * op applied between two swaps, a word read-modify-write that changes one byte,
 * a constant byte swap, constants stored to consecutive globals, and a long
 * stored from a frame slot. */
#include "test.h"
#include <intrinsic.h>

static unsigned char buf[8];
static unsigned char *ptr;
static unsigned int wg;
static unsigned char tmparg[4];
static long lg;

#define read_w(p)      (intrinsic_swap_endian_16(*(unsigned int *)(p)))
#define write_w(p, v)  (*(unsigned int *)(p) = intrinsic_swap_endian_16(v))

static unsigned int rd16(unsigned char *p) { return read_w(p); }
static void wr16(unsigned char *p, unsigned int v) { write_w(p, v); }
static unsigned int rd16_off(unsigned char *p) { return read_w(p + 2); }
static void copy16(unsigned char *d, unsigned char *s) { write_w(d, read_w(s)); }
static void setbit(void) { write_w(ptr, read_w(ptr) | 1); }
static void clrbit(void) { write_w(ptr, read_w(ptr) & 0xff7f); }
static void flipbit(void) { write_w(ptr, read_w(ptr) ^ 0x0100); }
static void orhi(void) { *(unsigned int *)ptr |= 0x0100; }
static void andhi(void) { *(unsigned int *)ptr &= 0x7fff; }
static void xorlo(void) { *(unsigned int *)ptr ^= 0x0002; }
static void gstore(unsigned int v) { wg = intrinsic_swap_endian_16(v); }

static void fillconst(void)
{
    tmparg[0] = tmparg[1] = tmparg[2] = tmparg[3] = 0xff;
}

static unsigned char zflag, nflag;

static void setflags(void)
{
    unsigned int i = read_w(ptr);
    zflag = nflag = 0;
    if (i == 0)
        zflag = 0xff;
    else if (i & 0x8000)
        nflag = 0xff;
}

static void storelong(long *p, long v)
{
    long t = v;
    *p = t;
}

void test_bswapmem(void)
{
    buf[0] = 0x12; buf[1] = 0x34; buf[2] = 0x56; buf[3] = 0x78;
    buf[4] = 0; buf[5] = 0; buf[6] = 0; buf[7] = 0;
    ptr = buf;
    assertEqual(rd16(buf), 0x1234);
    assertEqual(rd16_off(buf), 0x5678);
    wr16(buf + 4, 0xabcd);
    assertEqual(buf[4], 0xab);
    assertEqual(buf[5], 0xcd);
    copy16(buf + 6, buf);
    assertEqual(buf[6], 0x12);
    assertEqual(buf[7], 0x34);
    gstore(0x1234);
    assertEqual(wg, 0x3412);
    assertEqual(intrinsic_swap_endian_16(0x1234), 0x3412);
    assertEqual(intrinsic_swap_endian_16(0), 0);

    buf[0] = 0x12; buf[1] = 0x34;
    setbit();
    assertEqual(buf[0], 0x12);
    assertEqual(buf[1], 0x35);
    clrbit();
    assertEqual(buf[1], 0x35);
    buf[1] = 0xb5;
    clrbit();
    assertEqual(buf[1], 0x35);
    buf[1] = 0xff;
    clrbit();
    assertEqual(buf[1], 0x7f);
    flipbit();
    assertEqual(buf[1], 0x7f);
    assertEqual(buf[0], 0x13);

    buf[0] = 0x01; buf[1] = 0x00;
    orhi();
    assertEqual(buf[0], 0x01);
    assertEqual(buf[1], 0x01);
    buf[1] = 0xff;
    andhi();
    assertEqual(buf[0], 0x01);
    assertEqual(buf[1], 0x7f);
    xorlo();
    assertEqual(buf[0], 0x03);
    assertEqual(buf[1], 0x7f);

    fillconst();
    assertEqual(tmparg[0], 0xff);
    assertEqual(tmparg[1], 0xff);
    assertEqual(tmparg[2], 0xff);
    assertEqual(tmparg[3], 0xff);

    buf[0] = 0x00; buf[1] = 0x00;
    setflags();
    assertEqual(zflag, 0xff); assertEqual(nflag, 0);
    buf[0] = 0x80; buf[1] = 0x00;
    setflags();
    assertEqual(zflag, 0); assertEqual(nflag, 0xff);
    buf[0] = 0x00; buf[1] = 0x01;
    setflags();
    assertEqual(zflag, 0); assertEqual(nflag, 0);

    lg = 0;
    storelong(&lg, 0x12345678L);
    assertEqual(lg == 0x12345678L, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte swap with memory");
    suite_add_test(test_bswapmem);
    return suite_run();
}
