#include "test.h"
#include <stdio.h>
#include <stdlib.h>

/* Plain int and plain char bitfields are unsigned unless the declaration
   says signed. A 2-bit int holding 2 reads back as 2. */

struct sign_fields {
    int i : 2;
    signed int s : 3;
    unsigned int u : 3;
    char c : 3;
    signed char sc : 3;
    unsigned char uc : 3;
};

typedef int ti;

volatile ti voli;
ti *voli_ptr;

void test_bitfield_sign(void)
{
    struct sign_fields f;

    f.i = 2;
    f.s = -1;
    f.u = -1;
    f.c = -1;
    f.sc = -1;
    f.uc = -1;
    assertEqual(f.i, 2);
    assertEqual(f.s, -1);
    assertEqual(f.u, 7);
    assertEqual(f.c, 7);
    assertEqual(f.sc, -1);
    assertEqual(f.uc, 7);
}

void test_volatile_typedef(void)
{
    voli = 3;
    voli_ptr = &voli;
    assertEqual(voli, 3);
    assertEqual(*voli_ptr, 3);
}

int suite_typequal(void)
{
    suite_setup("Bitfield sign and typedef volatile");
    suite_add_test(test_bitfield_sign);
    suite_add_test(test_volatile_typedef);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_typequal();
    exit(res);
}
