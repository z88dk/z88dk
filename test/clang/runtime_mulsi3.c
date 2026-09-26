/* Runtime regression test for the ___mulsi3 bridge (32-bit `long` multiply).
 *
 * BACKGROUND: clang lowers `long * long` (and any 32-bit multiply) to a call
 * to compiler-rt's __mulsi3. z88dk's classic clib never had a symbol of that
 * name -- it ships DE:HL-layout math cores (l_mulu_32_32x32 etc.) reached
 * through its own naming/ABI. libsrc/l/llvmz80/__mulsi3.asm bridges clang's
 * ABI (one 32-bit operand in HL:DE, the other pushed on the stack lo-word
 * first, caller-cleaned, IX preserved) to the existing unsigned core
 * l_mulu_32_32x32 (DE:HL layout). The low 32 bits of a product are identical
 * for signed and unsigned operands, so the one unsigned core correctly
 * serves both signed and unsigned 32-bit multiply -- only sign of a WIDER
 * (64-bit) result would differ, which __mulsi3 never produces.
 *
 * RED (bridge missing or wrong): link fails, or products come out wrong
 *      (garbage register mapping, corrupted IX/frame pointer, or the wrong
 *      half of the DE:HL<->HL:DE swap).
 * GREEN: every product below matches the exact 32-bit truncated result.
 *
 * Cases exercise: two multi-digit positives (100000L*7L), the largest
 * 16-bit*16-bit unsigned corner case (65535L*65535L, which overflows 32 bits
 * has to truncate correctly), a negative*positive product, two negatives
 * (result positive), and multiply-by-zero/one identities.
 */
#include <stdio.h>

int main(void) {
    long a, b, r;
    int ok = 1;

    a = 100000L; b = 7L; r = a * b;
    if (r != 700000L) { printf("FAIL case1 got %ld want 700000\n", r); ok = 0; }

    a = 65535L; b = 65535L; r = a * b;
    /* 65535*65535 = 4294836225, truncated to 32 bits (long is 32-bit here)
       is 4294836225 itself since it fits in 32 bits unsigned, but as a
       signed 32-bit long it wraps to -131071. */
    if (r != -131071L) { printf("FAIL case2 got %ld want -131071\n", r); ok = 0; }

    a = -12345L; b = 6789L; r = a * b;
    if (r != -83810205L) { printf("FAIL case3 got %ld want -83810205\n", r); ok = 0; }

    a = -1000L; b = -2000L; r = a * b;
    if (r != 2000000L) { printf("FAIL case4 got %ld want 2000000\n", r); ok = 0; }

    a = 123456789L; b = 0L; r = a * b;
    if (r != 0L) { printf("FAIL case5 got %ld want 0\n", r); ok = 0; }

    a = 123456789L; b = 1L; r = a * b;
    if (r != 123456789L) { printf("FAIL case6 got %ld want 123456789\n", r); ok = 0; }

    if (ok)
        printf("mulsi3 OK\n");
    return ok ? 0 : 1;
}
