/* Branch relaxation size model: a branch over 40 one-byte register
 * instructions spans 40 bytes, well inside the jr range, but the loose model
 * charges 4 bytes a line. The Makefile checks the rendered asm: the branch
 * is `jr` on CPUs with the exact model and stays `jp` on ez80/kc160, whose
 * model is loose in a function that contains an __asm block.
 */
#include "test.h"

unsigned char spin(unsigned char n)
{
    if (n) {
#asm
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
        ld a,h
#endasm
        n--;
    }
    return n;
}

static void check(void)
{
    assertEqual(spin(3), 2);
    assertEqual(spin(0), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("relaxed branch over register-only asm");
    suite_add_test(check);
    return suite_run();
}
