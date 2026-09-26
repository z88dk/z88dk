/* Regression test for ravn/z88dk itoa/ltoa/ultoa bridges under llvmz80.
 *
 * These functions use __ZPROTO3 reversed-arg dispatch: itoa(num,buf,radix)
 * maps to ___itoa(radix,buf,num) in the llvmz80 ABI bridge.  The bridge
 * in libsrc/l/llvmz80/__itoa.asm adapts the ZPROTO3 register/stack layout
 * to the asm_itoa/asm_ltoa/asm_ultoa worker register convention.
 *
 * Green: prints "PASS itoa/ltoa/ultoa bridges correct"
 * Red  : prints "FAIL <fn> [<wrong>]" or hangs (stack corruption)
 */
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

char gbuf[32];  /* global to avoid BSS-only addressing */

int main(void) {
    int ok = 1;

    /* itoa: decimal */
    itoa(42, gbuf, 10);
    if (strcmp(gbuf, "42") != 0)  { printf("FAIL itoa(42) [%s]\n", gbuf); ok = 0; }

    itoa(-7, gbuf, 10);
    if (strcmp(gbuf, "-7") != 0)  { printf("FAIL itoa(-7) [%s]\n", gbuf); ok = 0; }

    itoa(0, gbuf, 10);
    if (strcmp(gbuf, "0") != 0)   { printf("FAIL itoa(0)  [%s]\n", gbuf); ok = 0; }

    /* ltoa: decimal */
    ltoa(100000L, gbuf, 10);
    if (strcmp(gbuf, "100000") != 0)  { printf("FAIL ltoa(100000) [%s]\n", gbuf); ok = 0; }

    ltoa(-100000L, gbuf, 10);
    if (strcmp(gbuf, "-100000") != 0) { printf("FAIL ltoa(-100000) [%s]\n", gbuf); ok = 0; }

    /* ultoa: decimal + binary */
    ultoa(65535UL, gbuf, 10);
    if (strcmp(gbuf, "65535") != 0) { printf("FAIL ultoa(65535,10) [%s]\n", gbuf); ok = 0; }

    ultoa(10UL, gbuf, 2);
    if (strcmp(gbuf, "1010") != 0)  { printf("FAIL ultoa(10,2) [%s]\n", gbuf); ok = 0; }

    if (ok) printf("PASS itoa/ltoa/ultoa bridges correct\n");
    return 0;
}
