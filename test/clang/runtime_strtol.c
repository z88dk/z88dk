/* Runtime regression test for strtol/strtoul/strncmp bridges (llvmz80).
 *
 * Pre-fix bugs:
 *   - strtol("99",&end,10) returned 6488064 (0x00630000) -- sccz80 DE=high/HL=low
 *     returned to caller expecting DE=low/HL=high; missing ex de,hl in bridge.
 *   - strtoul had the same return-convention bug.
 *   - Both also had a stack corruption bug (pop hl; ex (sp),hl consumed the
 *     caller-cleaned stack arg prematurely); fixed with a peek approach.
 *   - strncmp("abc","abd",3) returned -205 instead of a negative value --
 *     the bridge had the wrong register order for s1/s2 when calling asm_strncmp.
 *
 * The program prints a single result line the .sh harness matches exactly.
 */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    char *end;
    long r1  = strtol("99", &end, 10);       /* 99 */
    long r2  = strtol("0xff", NULL, 0);      /* 255 */
    long r3  = strtol("-42", NULL, 10);      /* -42 */
    unsigned long u1 = strtoul("65535", NULL, 10); /* 65535 */

    int c1 = strncmp("abc", "abc", 3);       /* 0  */
    int c2 = strncmp("abc", "abd", 3) < 0;  /* 1  (abc < abd) */
    int c3 = strncmp("abd", "abc", 3) > 0;  /* 1  (abd > abc) */
    int c4 = strncmp("abc", "abcd", 3);      /* 0  (equal to n=3) */

    printf("strtol %ld %ld %ld %lu %d %d %d %d\n",
           r1, r2, r3, u1, c1, c2, c3, c4);
    fflush(stdout);
    return 0;
}
