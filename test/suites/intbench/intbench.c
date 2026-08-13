/*
 * intbench.c — int-heavy real-world benchmark for compiler comparison.
 *
 * Workload: CRC-16-CCITT (poly 0x1021) over a 1 KB buffer, repeated
 * 63 times, plus a bitwise hash mix over a 256-entry word table.
 *
 * CRC-16-CCITT is a real-world 16-bit checksum used in X.25, HDLC,
 * Bluetooth, smart cards, IrDA, SD/MMC commands, and many serial
 * protocols. The implementation is the textbook bit-by-bit variant
 * (no lookup table), so the inner loop is pure 16-bit arithmetic:
 * XOR with shifted byte, conditional XOR with polynomial, left
 * shift through bit. Hot pattern for int-arithmetic emission.
 *
 * The bitwise mix afterwards iterates a word array, doing AND/OR/
 * XOR/rotate-left on 16-bit values to exercise the rest of the
 * walker's int paths (mirrors MD5's FF/GG/HH/II round shape on
 * 16-bit ints).
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define BUF_LEN 1024
#define REPS    63

static unsigned char buffer[BUF_LEN];

/*
 * Standard CRC-16-CCITT, bit-by-bit, initial value 0xFFFF, poly
 * 0x1021. No table — pure inner-loop int arithmetic.
 */
static unsigned int crc16_ccitt(unsigned char *data, unsigned int len)
{
    unsigned int crc = 0xFFFFU;
    unsigned char *end = data + len;
    while (data < end) {
        crc ^= ((unsigned int)*data++) << 8;
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
        crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    }
    return crc;
}

/*
 * MD5-round-style bitwise mix on 16-bit ints. Mirrors FF/GG/HH/II:
 * a/b/c/d round-state with AND/OR/NOT/XOR feeding back into a from
 * a word-array message tap. Triggers the int AND/OR/NOT/XOR walker
 * paths plus left-rotate via shift|shift. The multi-declarator
 * preamble + C99 for-decl shape was the #258 miscompile trigger.
 */
static unsigned int mix_table(unsigned int *tab, unsigned int n)
{
    unsigned int a = 0x6745U, b = 0xEFCDU, c = 0x98BAU, d = 0x1032U;
    for (unsigned int i = 0; i < n; i++) {
        unsigned int t = tab[i & 0x0FU];
        a = a + ((b & c) | ((~b) & d)) + t + 0x7891U;
        a = (a << 5) | (a >> 11);  /* rotate-left 5 */
        d = c; c = b; b = a;
        a = d;
    }
    return a ^ b ^ c ^ d;
}

/* Fill buffer deterministically. */
static void init_data(void)
{
    unsigned int i;
    unsigned int seed = 0xC001U;
    for (i = 0; i < BUF_LEN; i++) {
        buffer[i] = (unsigned char)(seed & 0xFFU);
        seed = (unsigned int)(seed * 25173U + 13849U);
    }
}

static void intbench_run(void)
{
    unsigned int crc = 0;
    unsigned int rep;

    init_data();

    for (rep = 0; rep < REPS; rep++) {
        crc ^= crc16_ccitt(buffer, BUF_LEN);
    }

    assertEqual(crc, 0xEE7EU);

    /* mix_table uses the first 16 words of the buffer as the message
       tap (interpreted little-endian). 4096-iter mix; expected value
       computed by host program. */
    unsigned int mixed = mix_table((unsigned int *)buffer, 4096U);
    assertEqual(mixed, 0xF37BU);
}

int suite_intbench(void)
{
    suite_setup("INT-bench Tests");
    suite_add_test(intbench_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_intbench();
    exit(res);
}
