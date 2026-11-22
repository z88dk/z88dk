/*
 * charbench.c — char-heavy benchmark for compiler comparison.
 *
 * Mirrors intbench's structure but on 8-bit data. Two passes, one
 * per signedness:
 *
 *   1. crc8_ccitt (unsigned char) — bit-by-bit CRC-8-CCITT (poly 0x07,
 *      init 0xFF) repeated REPS times over the same 1 KB buffer.
 *      Real-world checksum used in I2C, OneWire, ATM cell headers,
 *      Bluetooth HCI. Pure inner-loop unsigned-byte arithmetic: ^=,
 *      &, <<, conditional XOR with polynomial. Stresses the walker's
 *      unsigned-char compare-with-const fastpath, char shift, and
 *      char widen-when-needed paths.
 *
 *   2. schar_mix (signed char) — sign-conditional accumulator mix
 *      over the buffer reinterpreted as signed bytes. Exercises
 *      signed-char compare-with-const, sign-extension on load, and
 *      signed += / -= on a char accumulator.
 *
 * Same deterministic 1 KB seed as intbench, so cross-bench cache
 * behaviour and frame layout are comparable. Expected results
 * computed by a host program (see expected.txt).
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define BUF_LEN 1024
#define REPS    63

static unsigned char buffer[BUF_LEN];

/*
 * CRC-8-CCITT, bit-by-bit, init 0xFF, poly 0x07. No table — pure
 * inner-loop unsigned-byte arithmetic. The eight unrolled bit
 * iterations per data byte are the hot path; each is a char-AND,
 * char-shift, and a conditional char-XOR.
 */
static unsigned char crc8_ccitt(unsigned char *data, unsigned int len)
{
    unsigned char crc = 0xFFU;
    unsigned char *end = data + len;
    while (data < end) {
        crc ^= *data++;
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
        crc = (crc & 0x80U) ? ((unsigned char)(crc << 1) ^ 0x07U) : (unsigned char)(crc << 1);
    }
    return crc;
}

/*
 * Sign-conditional mix on signed bytes. For each byte b:
 *   if (b < 0) acc -= b; else acc += b;
 *   acc = (acc << 1) ^ b;   (LFSR-style — doesn't degenerate)
 * Exercises the signed-char compare-with-zero / compare-with-const
 * fastpaths, sign-extension on byte loads where the result is
 * compared signed, and char accumulator += / -=. The shift is
 * left-by-1 on a signed char so the walker has to widen-and-narrow
 * (signed shift behaviour) on every iteration.
 */
static signed char schar_mix(signed char *data, unsigned int len)
{
    signed char acc = -1;
    signed char *end = data + len;
    while (data < end) {
        signed char b = *data++;
        if (b < 0) {
            acc = (signed char)(acc - b);
        } else {
            acc = (signed char)(acc + b);
        }
        acc = (signed char)((acc << 1) ^ b);
    }
    return acc;
}

/*
 * Deterministic 1 KB fill. Same seed/LCG as intbench so the input
 * data matches and cross-bench comparisons are meaningful.
 */
static void init_data(void)
{
    unsigned int i;
    unsigned int seed = 0xC001U;
    for (i = 0; i < BUF_LEN; i++) {
        buffer[i] = (unsigned char)(seed & 0xFFU);
        seed = (unsigned int)(seed * 25173U + 13849U);
    }
}

static void charbench_run(void)
{
    unsigned char crc;
    unsigned int rep;

    init_data();

    /* unsigned char path */
    crc = 0;
    for (rep = 0; rep < REPS; rep++) {
        crc ^= crc8_ccitt(buffer, BUF_LEN);
    }
    assertEqual(crc, 0x4EU);

    /* signed char path — REPS reps so the workload is comparable in
       scale to the unsigned half. Each rep is independent because
       schar_mix is pure. The XOR chain over odd REPS reduces to the
       per-pass value, which we assert against. */
    signed char mix = 0;
    for (rep = 0; rep < REPS; rep++) {
        mix = (signed char)(mix ^ schar_mix((signed char *)buffer, BUF_LEN));
    }
    assertEqual((unsigned char)mix, 0xB2U);
}

int suite_charbench(void)
{
    suite_setup("CHAR-bench Tests");
    suite_add_test(charbench_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_charbench();
    exit(res);
}
