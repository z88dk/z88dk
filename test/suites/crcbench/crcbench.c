/*
 * crcbench.c — long-heavy benchmark for compiler comparison.
 *
 * Workload: CRC-32 (zip/ethernet variant, polynomial 0xEDB88320 in
 * reversed form), bit-by-bit, over a 1 KB deterministic buffer
 * repeated REPS times. Same buffer fill as intbench / charbench so
 * cross-bench cache behaviour is comparable.
 *
 * CRC-32 is the canonical workload for stressing 32-bit XOR / AND /
 * right-shift / conditional XOR — the four hot ops in compression,
 * checksum, and integer hash routines. The inner-loop shape
 *
 *     crc = (crc & 1) ? ((crc >> 1) ^ 0xEDB88320) : (crc >> 1);
 *
 * exercises walker long shift, long AND with byte literal, and
 * long XOR with a wide const — exactly the binop family that
 * dominates md5sum's transform but at narrower kernel granularity.
 *
 * Real-world CRC-32 is used in zip/gzip, PNG, Ethernet, SATA,
 * MPEG-2, POSIX cksum, and many serial protocols.
 */

#include <stdio.h>
#include <stdlib.h>
#include "test.h"

#define BUF_LEN 1024
#define REPS    63

static unsigned char buffer[BUF_LEN];

/*
 * Standard CRC-32, bit-by-bit, reversed-polynomial form. Init
 * 0xFFFFFFFF, final XOR 0xFFFFFFFF. No table — pure inner-loop
 * 32-bit arithmetic.
 */
static unsigned long crc32(unsigned char *data, unsigned int len)
{
    unsigned long crc = 0xFFFFFFFFUL;
    unsigned char *end = data + len;
    while (data < end) {
        crc ^= (unsigned long)*data++;
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
        crc = (crc & 1UL) ? ((crc >> 1) ^ 0xEDB88320UL) : (crc >> 1);
    }
    return crc ^ 0xFFFFFFFFUL;
}

/*
 * Deterministic 1 KB fill. Same seed/LCG as intbench / charbench
 * so the input data matches across benches.
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

static void crcbench_run(void)
{
    unsigned long crc = 0;
    unsigned int rep;

    init_data();

    for (rep = 0; rep < REPS; rep++) {
        crc ^= crc32(buffer, BUF_LEN);
    }

    /* Expected value computed by host (see comment at the assertEqual
       below). The XOR-chain over the standard 1 KB buffer × REPS reps
       is stable across hosts because CRC-32 itself is host-independent
       and the buffer fill is deterministic. */
    assertEqual(crc, 0x1C48DD57UL);
}

int suite_crcbench(void)
{
    suite_setup("CRC-32 bench Tests");
    suite_add_test(crcbench_run);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;
    res += suite_crcbench();
    exit(res);
}
