/* runtime_stdmisc.c -- runtime test for the misc-number + ctype bridges wired
 * into z88dk for `-compiler=llvmz80`.
 *
 * abs/labs regression: clang defines __STDC_ABI_ONLY, which disables the
 * `#define abs abs_fastcall` fastcall routing in <stdlib.h>.  The plain classic
 * `abs`/`labs` entries are __smallc (stack ABI) while clang passes the argument
 * in HL/DE:HL -> mismatch (abs(-42) returned 1199).  The `#elif defined
 * (__LLVMZ80)` branch routes them to abs_fastcall/labs_fastcall (z80_fastcall,
 * register in/out).  This test reads the results at runtime so a wrong ABI
 * shows up as a wrong value.
 *
 * ctype family: isdigit/isalpha/... and toupper/tolower exercised for a few
 * representative inputs.
 */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(void)
{
    /* abs/labs: negative, positive, zero */
    printf("abs %d %d %d\n", abs(-42), abs(7), abs(0));
    printf("labs %ld %ld\n", labs(-99L), labs(123456L));

    /* rand is deterministic for a fixed seed */
    srand(1); int a = rand();
    srand(1); int b = rand();
    printf("rand %d\n", a == b);

    /* ctype predicates: 1 if the class holds, else 0 */
    printf("ct %d%d%d%d%d%d\n",
        isdigit('7') != 0, isalpha('x') != 0, isspace(' ') != 0,
        isupper('A') != 0, islower('a') != 0, isalnum('9') != 0);
    /* and the negative controls */
    printf("nct %d%d%d\n",
        isdigit('x') != 0, isalpha('3') != 0, isspace('z') != 0);

    /* case conversion (letters change, digits pass through) */
    printf("cv %c%c%c\n", (char)toupper('a'), (char)tolower('Z'), (char)toupper('5'));

    return 0;
}
