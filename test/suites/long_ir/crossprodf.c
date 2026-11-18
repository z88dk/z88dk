/* Cross product of float vectors, results stored through one pointer. */
#include "test.h"

typedef struct { float x, y, z; } VF;

static void crossf(VF *a, VF *b, VF *r)
{
    float x, y, z;
    x = (a->y * b->z) - (a->z * b->y);
    y = (a->z * b->x) - (a->x * b->z);
    z = (a->x * b->y) - (a->y * b->x);
    r->x = x; r->y = y; r->z = z;
}

static void check(void)
{
    VF a = { 2.0f, 3.0f, 5.0f }, b = { 7.0f, 11.0f, 13.0f }, r = { 0, 0, 0 };

    crossf(&a, &b, &r);
    assertEqual(r.x == -16.0f, 1);
    assertEqual(r.y == 9.0f, 1);
    assertEqual(r.z == 1.0f, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("float cross product chain store");
    suite_add_test(check);
    return suite_run();
}
