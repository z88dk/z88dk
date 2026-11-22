/* A BYTE LOADED THROUGH A POINTER GOES STRAIGHT TO ITS REGISTER.
 *
 *     ld a,(hl); ld e,a   ->   ld e,(hl)        (likewise (ix+d), (iy+d))
 *
 * Legal only where A is dead afterwards: the fold deletes the instruction that
 * puts the byte in A. Every case that reads the byte again through A must keep
 * its value, so each one is checked by value. The folding cases index a global
 * table with a pointer-read or parameter byte, the shape that produced
 * `ld a,(ix+4); ld e,a; ld d,0`.
 */
#include "test.h"

static unsigned char tab[16] = { 3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3 };
static unsigned char src[8]  = { 7, 0, 15, 2, 255, 128, 1, 9 };
static int sink;

static int idx_param(unsigned char i)           { return tab[i & 15]; }
static int idx_ptr(unsigned char *p)            { return tab[*p & 15]; }
static int idx_two(unsigned char *p, unsigned char i) { return tab[*p & 15] + tab[i & 15]; }

/* the byte is read again after the widening: A must still hold it */
static int reuse_sum(unsigned char *p)
{
    unsigned char c = *p;
    return (c << 8) | c;
}
static int reuse_after_call(unsigned char *p)
{
    unsigned char c = *p;
    sink = c;
    return c + sink;
}
static unsigned char reuse_ret(unsigned char *p)
{
    unsigned char c = *p;
    sink = tab[c & 15];
    return c;
}
static int walk(unsigned char *p, int n)
{
    int s = 0;
    while (n--) { unsigned char c = *p++; s += tab[c & 15] + c; }
    return s;
}
static int two_ptrs(unsigned char *p, unsigned char *q)
{
    unsigned char a = *p, b = *q;
    return a * 3 + b;
}

void test_ldirect(void)
{
    int i, s;
    for (i = 0; i < 16; i++) assertEqual(idx_param((unsigned char)i), tab[i]);
    assertEqual(idx_param(0x1f), tab[15]);
    for (i = 0; i < 8; i++) {
        assertEqual(idx_ptr(&src[i]), tab[src[i] & 15]);
        assertEqual(idx_two(&src[i], (unsigned char)(i + 3)), tab[src[i] & 15] + tab[(i + 3) & 15]);
        assertEqual(reuse_sum(&src[i]), (src[i] << 8) | src[i]);
        assertEqual(reuse_after_call(&src[i]), 2 * src[i]);
        assertEqual(reuse_ret(&src[i]), src[i]);
        assertEqual(sink, tab[src[i] & 15]);
        assertEqual(two_ptrs(&src[i], &src[7 - i]), src[i] * 3 + src[7 - i]);
    }
    s = 0;
    for (i = 0; i < 8; i++) s += tab[src[i] & 15] + src[i];
    assertEqual(walk(src, 8), s);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte load through a pointer goes straight to its register");
    suite_add_test(test_ldirect);
    return suite_run();
}
