/* runtime_large_array.c -- regression test for large string and byte arrays.
 *
 * Checks that large arrays (e.g. 2048-byte font tables or long strings)
 * compile, link, and read back identical contents under -compiler=llvmz80
 * without relying on external split passes (such as splitascii.pl).
 */
#include <stdio.h>
#include <stdint.h>

#define TABLE_SIZE 2048

/* 2048-byte table (simulates font / ROM chargen table) */
const unsigned char large_table[TABLE_SIZE] = {
    [0]    = 0x12,
    [47]   = 0x34,
    [48]   = 0x56,
    [1023] = 0x78,
    [2047] = 0x9A
};

/* Long string literal (> 500 chars, exceeds old copt MAXLINE) */
const char long_str[] =
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
    "END";

int main(void) {
    int ok = 1;

    /* Verify table size and contents */
    if (sizeof(large_table) != 2048) ok = 0;
    if (large_table[0] != 0x12) ok = 0;
    if (large_table[47] != 0x34) ok = 0;
    if (large_table[48] != 0x56) ok = 0;
    if (large_table[1023] != 0x78) ok = 0;
    if (large_table[2047] != 0x9A) ok = 0;

    /* Verify string length and ends */
    if (sizeof(long_str) != (8 * 64 + 3 + 1)) ok = 0;
    if (long_str[0] != '0') ok = 0;
    if (long_str[sizeof(long_str) - 4] != 'E') ok = 0;
    if (long_str[sizeof(long_str) - 3] != 'N') ok = 0;
    if (long_str[sizeof(long_str) - 2] != 'D') ok = 0;
    if (long_str[sizeof(long_str) - 1] != '\0') ok = 0;

    printf("large_array ok=%d\n", ok);
    return ok ? 0 : 1;
}
