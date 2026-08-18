/* 32-bit integer divide/modulo: self-verifying, no golden values.
 *
 * Every case asserts the division identity  q*d + r == n  with  r < d, which
 * holds for any correct implementation, so the same source is a valid gate on
 * every CPU and needs no reference table. Cases are chosen to cover the shapes
 * a divide core dispatches on:
 *
 *   - 16-bit divisors, which the 8085 core takes on a register-only fast path
 *     (l_long_div_0.asm div16) and the z80 fast-math family dispatches to
 *     l_fast_divu_32_32x16. This is the common case in C: a long divided by an
 *     int or a small constant.
 *   - divisors either side of 0x8000, where the running remainder needs a 17th
 *     bit and the trial subtraction becomes unconditional.
 *   - genuine 32-bit divisors, powers of two, and 1 / 0xFFFFFFFF boundaries.
 *   - signed division in all four sign combinations.
 *
 * Values come from a runtime LCG and from runtime-written globals so nothing
 * can be constant-folded into the answer.
 */
#include "test.h"

static unsigned long g_n, g_d;

static void check_u(unsigned long n, unsigned long d)
{
    unsigned long q, r;
    g_n = n; g_d = d;                 /* via memory: no folding */
    q = g_n / g_d;
    r = g_n % g_d;
    Assert(q * d + r == n, "q*d + r == n");
    Assert(r < d, "remainder < divisor");
}

static void check_s(long n, long d)
{
    long q, r;
    q = n / d;
    r = n % d;
    Assert(q * d + r == n, "signed q*d + r == n");
}

void test_div_16bit_divisor(void)
{
    unsigned long n = 0x12345678UL;
    unsigned int i;
    unsigned long d = 1UL;
    for (i = 0; i < 120; i++) {
        n = n * 1103515245UL + 12345UL;
        d = (d * 40503UL + 7UL) & 0xFFFFUL;
        if (d == 0) d = 1;
        check_u(n, d);
    }
    check_u(0xFFFFFFFFUL, 0xFFFFUL);
    check_u(0xFFFFFFFFUL, 1UL);
    check_u(0UL, 0xFFFFUL);
    check_u(0x10000UL, 0x10000UL - 1UL);
}

void test_div_remainder_17th_bit(void)
{
    unsigned long d;
    unsigned int i;
    /* divisors > 0x8000 make 2*r + bit exceed 16 bits */
    for (d = 0x7FFDUL; d <= 0x8003UL; d++)
        for (i = 0; i < 12; i++)
            check_u(0xFFFFFFFFUL - (unsigned long)i * 0x01010101UL, d);
    check_u(0xFFFFFFFFUL, 0x8000UL);
    check_u(0x80000000UL, 0x8000UL);
}

void test_div_32bit_divisor(void)
{
    check_u(0xFFFFFFFFUL, 0xFFFFFFFFUL);
    check_u(0xFFFFFFFFUL, 0x80000000UL);
    check_u(0xFFFFFFFEUL, 0x7FFFFFFFUL);
    check_u(0x12345678UL, 0x00010001UL);
    check_u(0xDEADBEEFUL, 0x00123456UL);
    check_u(1UL, 0xFFFFFFFFUL);
    check_u(0x10000UL, 0x10000UL);
    check_u(0x10001UL, 0x10000UL);
}

void test_div_powers_of_two(void)
{
    unsigned long d;
    for (d = 1UL; d <= 0x10000UL; d <<= 1) {
        check_u(0xFFFFFFFFUL, d);
        check_u(0x89ABCDEFUL, d);
    }
}

void test_div_signed(void)
{
    check_s(12345L, 7L);
    check_s(-12345L, 7L);
    check_s(12345L, -7L);
    check_s(-12345L, -7L);
    check_s(2000000000L, 65535L);
    check_s(-2000000000L, 65535L);
    check_s(2000000000L, -65535L);
    check_s(-2000000000L, -65535L);
    check_s(0L, -3L);
    check_s(-1L, 1L);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("32-bit integer divide");
    suite_add_test(test_div_16bit_divisor);
    suite_add_test(test_div_remainder_17th_bit);
    suite_add_test(test_div_32bit_divisor);
    suite_add_test(test_div_powers_of_two);
    suite_add_test(test_div_signed);
    return suite_run();
}
