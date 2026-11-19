/* Three results of products stored through one pointer: the last result is
 * parked on the stack while the earlier two are stored as a chain.
 */
#include "test.h"

typedef struct { int x, y, z; } V;

static void cross(V *a, V *b, V *r)
{
    int x, y, z;
    x = (a->y * b->z) - (a->z * b->y);
    y = (a->z * b->x) - (a->x * b->z);
    z = (a->x * b->y) - (a->y * b->x);
    r->x = x; r->y = y; r->z = z;
}

static void check(void)
{
    V a = { 2, 3, 5 }, b = { 7, 11, 13 }, r = { 0, 0, 0 };

    cross(&a, &b, &r);
    assertEqual(r.x, 3 * 13 - 5 * 11);
    assertEqual(r.y, 5 * 7 - 2 * 13);
    assertEqual(r.z, 2 * 11 - 3 * 7);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("chain store of a parked value");
    suite_add_test(check);
    return suite_run();
}
