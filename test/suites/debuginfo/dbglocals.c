/* Debug-info regression for #3233 (80cc, -debug): named locals that the
 * optimiser used to keep out of their frame slot. check_locals.sh breaks at
 * each marked line and asserts the value `info locals` shows.
 */
#include <stdio.h>
#include <stdint.h>

uint8_t g8;
uint8_t ga = 0x34, gb = 0x12;
uint16_t gw;

uint8_t twice(uint8_t v)        /* tiny: would be sp-flipped */
{
    uint8_t r;
    r = v + v;
    r = r + 1;                  /* readers of r are copy-propagated */
    return r;                   /* BREAK twice: r = 7 */
}

void konst(void)                /* frameless without -debug */
{
    uint8_t loc = 3;            /* constant-initialised, never reassigned */
    g8 = loc + g8;              /* BREAK konst: loc = 3 */
}

void narrow(void)
{
    int t = ga + gb * 256;      /* an int only used as a byte */
    g8 = t;
    g8 = g8 + 1;                /* BREAK narrow: t = 4660 */
}

uint16_t gq = 0x1234;

void rmw(void)
{
    uint16_t v = gq;            /* a load / bit-op / store chain of named locals */
    uint16_t m = v | 0x0001;
    gq = m;
    g8 = 1;                     /* BREAK rmw: v = 4660, m = 4661 */
}

uint16_t count(uint16_t m)
{
    uint16_t k = m;             /* BREAK count: n has a record (a line after a loop starts at a BB label, which ticks cannot resolve) */
    for (int n = 0; n < 3; n++)
        k += 2;
    gw = k;
    return k;
}

#ifdef __Z80
uint8_t fcb(uint8_t c) __z88dk_fastcall   /* its whole frame is the pushed param */
{
    g8 = c + 1;                 /* BREAK fcb: c = 9 */
    return g8;
}

uint16_t sc1(uint16_t a, uint8_t b) __sdcccall(1)
{
    uint16_t s = a + b;
    gw = s;                     /* BREAK sc1: a = 10, b = 5, s = 15 */
    return s;
}
#endif

int main(void)
{
    g8 = twice(3);
    konst();
    narrow();
    rmw();
    gw = count(1);
#ifdef __Z80
    g8 = fcb(9);
    gw = sc1(10, 5);
#endif
    printf("%u %u\n", g8, gw);
    return 0;
}
