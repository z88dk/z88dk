/*
 * r_IntersectRect16 passes the result pointer to RIntersectRect16 in IX, so
 * the C wrapper must give the caller's IX (frame pointer in 80cc/sdcc fp
 * code) back.
 */

#include <rect.h>
#include "ixsave_tests.h"

static void intersect_rect16_tests()
{
    struct r_Rect16 a = { 10, 20, 10, 20 };
    struct r_Rect16 b = { 20, 20, 25, 20 };
    struct r_Rect16 c = { 100, 5, 100, 5 };
    struct r_Rect16 r;
    int             keep = 0x1357;
    unsigned        ix0, ix1;
    int             n;

    r.x = r.width = r.y = r.height = 0xdead;
    ix0 = ix_get();
    n = r_IntersectRect16(&a, &b, &r);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x1357);
    assertEqual(n, 1);
    assertEqual(r.x, 20);
    assertEqual(r.width, 10);
    assertEqual(r.y, 25);
    assertEqual(r.height, 5);

    /* no intersection: result untouched */
    r.x = r.width = r.y = r.height = 0xdead;
    ix0 = ix_get();
    n = r_IntersectRect16(&a, &c, &r);
    ix1 = ix_get();
    assertEqual(ix0, ix1);
    assertEqual(keep, 0x1357);
    assertEqual(n, 0);
    assertEqual(r.x, 0xdead);
}

int test_rect()
{
    suite_setup("r_IntersectRect16 IX preservation");
    suite_add_test(intersect_rect16_tests);

    return suite_run();
}
