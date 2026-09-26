/* runtime_long.c -- 32-bit (long) argument/return ABI across the clib boundary.
 *
 * GREEN: signed and unsigned long div/mod and a long round-trip through printf
 *        (%ld/%lu) are correct.  Exercises the 32-bit ABI (DEHL / stack) that
 *        __divmodsi4 / __udivmodsi4 and the variadic long promotion depend on.
 *        Portable: passes under both the classic clib and newlib (the 32-bit
 *        ABI itself is fine on newlib; only the __attribute__ idiom breaks it,
 *        which this test deliberately avoids -- see runtime_attr).
 */
#include <stdio.h>

int main(void) {
    volatile long a = 1000003L, b = 997L;
    volatile unsigned long ua = 4000000000UL, ub = 123457UL;
    printf("q=%ld r=%ld uq=%lu ur=%lu\n", a / b, a % b, ua / ub, ua % ub);
    return 0;
}
