#include "test.h"
#include <stdio.h>
#include <stdlib.h>

struct S {
    int x;
    char y;
    int z;
};

struct T {
    struct S inner;
    char c;
    int d;
};

struct B {
    unsigned a : 3;
    signed int b : 4;
    unsigned c : 4;
};

union U {
    int x;
    char y[3];
};

struct S gt = {4, 5, 6};
const struct S ct = {1, 2, 3};

typedef struct S S;

struct S *gp(void)
{
    return &gt;
}

void test_brace(void)
{
    struct S t = {1, 2, 3};
    struct S s;

    s = t;
    assertEqual(s.x, 1);
    assertEqual((int)s.y, 2);
    assertEqual(s.z, 3);
    t.x = 9;
    assertEqual(s.x, 1);
}

#ifndef __80CC
void test_copy(void)
{
    struct S t = {4, 5, 6};
    struct S s = t;
    struct T src = {{7, 8, 9}, 10, 11};
    struct T dst = src;
    struct S inner = src.inner;
    struct S from_g = gt;
    struct S from_c = ct;
    S from_td = gt;
    struct S *p = &gt;
    struct S from_p = *p;
    struct S from_call = *gp();
    union U a = {0x1234};
    union U b = a;
    struct B bf;
    struct B bg;

    t.x = 9;
    assertEqual(s.x, 4);
    assertEqual((int)s.y, 5);
    assertEqual(s.z, 6);

    assertEqual(dst.inner.x, 7);
    assertEqual((int)dst.inner.y, 8);
    assertEqual(dst.inner.z, 9);
    assertEqual((int)dst.c, 10);
    assertEqual(dst.d, 11);
    src.d = 0;
    assertEqual(dst.d, 11);

    assertEqual(inner.x, 7);
    assertEqual(inner.z, 9);
    assertEqual(from_g.x, 4);
    assertEqual(from_g.z, 6);
    assertEqual(from_c.x, 1);
    assertEqual((int)from_c.y, 2);
    assertEqual((int)from_td.y, 5);
    assertEqual(from_p.x, 4);
    assertEqual((int)from_p.y, 5);
    assertEqual(from_call.x, 4);
    assertEqual(from_call.z, 6);

    assertEqual(b.x, 0x1234);
    a.x = 0;
    assertEqual(b.x, 0x1234);

    bf.a = 5;
    bf.b = -2;
    bf.c = 3;
    bg = bf;
    {
        struct B copy = bf;

        assertEqual((int)copy.a, (int)bf.a);
        assertEqual((int)copy.b, (int)bf.b);
        assertEqual((int)copy.c, (int)bf.c);
        bf.a = 1;
        assertEqual((int)copy.a, 5);
        assertEqual((int)copy.b, -2);
        assertEqual((int)bg.a, 5);
    }
}
#endif

int suite_structcopy(void)
{
    suite_setup("Structure copy initialiser");
    suite_add_test(test_brace);
#ifndef __80CC
    suite_add_test(test_copy);
#endif
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_structcopy();
    exit(res);
}
