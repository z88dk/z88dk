/* Integer lvalue compound-assigned from a 5/6-byte (accumulator tier) float:
 * `i += d` is i = (int)((double)i + d). The width of the lvalue (char, int,
 * long) and its signedness must both survive. Negative results are exact: the
 * library converts a negative fraction toward minus infinity.
 */
#include "test.h"

int gi;
unsigned char guc;
signed char gsc;
long gl;
double gd, gh, gn;

static int run(void)
{
    int bad = 0;
    int li;
    gd = 2.5; gh = 1.5; gn = 2.0;

    gi = 10;  gi += gd;  if (gi != 12) bad++;
    gi -= gd;            if (gi != 9) bad++;
    gi *= gd;            if (gi != 22) bad++;
    gi /= gd;            if (gi != 8) bad++;
    gi = -3;  gi += gn;  if (gi != -1) bad++;
    gi = gi + gd;        if (gi != 1) bad++;
    guc = 250; guc += 3.5; if (guc != 253) bad++;
    gsc = -5;  gsc -= gn;  if (gsc != -7) bad++;
    gl = 100000L; gl += gh; if (gl != 100001L) bad++;
    gl = -100000L; gl -= gn; if (gl != -100002L) bad++;
    li = 7; li += gd;    if (li != 9) bad++;
    return bad;
}

static void check(void)
{
    assertEqual(run(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("integer compound assign from an accumulator-tier float");
    suite_add_test(check);
    return suite_run();
}
