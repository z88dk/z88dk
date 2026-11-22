/* [self-ops] Block-local value equivalence: folds that hold for every value
 * (copies, complements, sums cancelling), and the shapes that must NOT fold
 * because an operand changed in between. */
#include "test.h"

static volatile unsigned int vk = 1;

static unsigned int cancel(unsigned int i)
{
    unsigned int j = i;
    j /= i;  j *= i;  j += i;  j -= i;      /* i/i = 1 for i != 0 */
    return j;
}

static unsigned int logic(unsigned int i)
{
    unsigned int j = ~i;
    j &= i;  j |= i;  j ^= i;
    return j;
}

/* an operand changes between the two halves: nothing may cancel */
static unsigned int changed(unsigned int i, unsigned int y)
{
    unsigned int s = i + y;
    y += 3;
    s -= y;
    return s;
}

static unsigned int changed2(unsigned int i)
{
    unsigned int j = ~i;
    i++;
    j &= i;
    return j;
}

static unsigned int mul_one(unsigned int x)
{
    unsigned int k = vk;            /* not a constant */
    unsigned int one = 1, zero = 0;
    return x * one + x * zero + x * k;
}

static unsigned int sub_add(unsigned int x, unsigned int y)
{
    unsigned int t = x - y;
    t += y;                         /* back to x */
    unsigned int u = x + y;
    u -= x;                         /* back to y */
    return t * 7 + u;
}

static unsigned int mod_self(unsigned int x)
{
    unsigned int m = x;
    return (m % x) + (m / x) * 10;
}

static unsigned char bytes(unsigned char c)
{
    unsigned char d = c;
    d ^= c;                         /* 0 */
    d |= c;                         /* c */
    d &= (unsigned char)~c;         /* 0 */
    return d + (unsigned char)(c - c);
}

static void test_selfops(void)
{
    unsigned int k;
    for (k = 1; k < 5000; k += 997) assertEqual(cancel(k), k);
    for (k = 0; k < 5000; k += 997) assertEqual(logic(k), 0U);
    assertEqual(changed(100, 7), (unsigned int)(100 + 7 - 10));
    assertEqual(changed(0x1234, 0xfff0), (unsigned int)(0x1234 + 0xfff0 - 3 - 0xfff0));
    assertEqual(changed2(5), (unsigned int)(~5U & 6U));
    assertEqual(changed2(0x00ff), (unsigned int)(~0x00ffU & 0x0100U));
    assertEqual(mul_one(9), 9U + 0U + 9U);
    assertEqual(sub_add(40, 3), 40U * 7 + 3U);
    assertEqual(sub_add(3, 40), 3U * 7 + 40U);
    assertEqual(mod_self(77), 10U);
    assertEqual(bytes(0xa5), 0);
}

int suite_selfops(void) { suite_setup("self operations"); suite_add_test(test_selfops); return suite_run(); }
int main(void) { return suite_selfops(); }
