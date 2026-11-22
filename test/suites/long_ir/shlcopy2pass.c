/* [shl-copy-de] `(int)l * 3` (and * 5, * 7, * 9) of a long: the rung must
 * take the same decision in both lazy-spill passes. Pass 1 stores the
 * truncated word with `pop de; push hl`, which clobbers DE, so the rung copies
 * it to DE and the add reads it from there; that store is then dead. Pass 2
 * drops it, so DEHL still holds the long; if the rung refuses there, the add
 * reloads the word from a slot that was never written.
 */
#include "test.h"

long gl;

int m3(void) { return (int)gl * 3; }
int m5(void) { return (int)gl * 5; }
int m7(void) { return (int)gl * 7; }
int m9(void) { return (int)gl * 9; }

/* The same with the long in a parameter, behind a pointer, in a static. */
int p3(long a) { return (int)a * 3; }
int d3(long *p) { long v = *p; return (int)v * 3; }
int s3(void) { static long sl = 0x30005L; return (int)sl * 3; }

static void check(void)
{
    long v = 0x30005L;

    gl = 0x30005L;
    assertEqual(m3(), 15);
    assertEqual(m5(), 25);
    assertEqual(m7(), 35);
    assertEqual(m9(), 45);

    gl = 0x7fff1234L;
    assertEqual(m3(), 0x1234 * 3);
    assertEqual(m7(), 0x1234 * 7);

    assertEqual(p3(0x30005L), 15);
    assertEqual(d3(&v), 15);
    assertEqual(s3(), 15);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("shl-copy-de decides the same in both lazy-spill passes");
    suite_add_test(check);
    return suite_run();
}
