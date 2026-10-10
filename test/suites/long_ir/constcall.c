/* A local assigned a constant keeps its value across calls unless its address
 * escaped; a callee that writes through a pointer must still be seen. Constant
 * byte arguments of both signs reach the callee zero- or sign-extended.
 */
#include "test.h"
#include <stdio.h>
#include <string.h>

static int seen[8];
static int nseen;

static int rec(int a, int b)         { seen[nseen++ & 7] = a * 10 + b; return a + b; }
static void poke(int *p)             { *p = 99; }
static void pokec(unsigned char *p)  { *p = 7; }

static int uconst(void)
{
    unsigned char c = 200;
    int r = rec(1, c);
    r += rec(2, c);
    return r;
}

static int sconst(void)
{
    signed char c = -3;
    int r = rec(1, c);
    r += rec(2, c);
    return r;
}

static int escaped(void)
{
    int v = 5;
    int a = rec(1, v);
    poke(&v);
    return a + rec(2, v);
}

static int escaped_byte(void)
{
    unsigned char c = 4;
    int a = rec(1, c);
    pokec(&c);
    return a + rec(2, c);
}

static int viaptr(void)
{
    int v = 5, *p = &v;
    int a = rec(1, v);
    *p = 8;
    return a + rec(2, v);
}

static int arr(void)
{
    char s[2];
    char c = 'A';
    s[0] = c;
    rec(0, 0);
    s[1] = c;
    return s[0] + s[1];
}

static int reassigned(void)
{
    unsigned char c = 3;
    int a = rec(1, c);
    c = 9;
    return a + rec(2, c);
}

static int variadic(void)
{
    char buf[16];
    signed char c = -3;
    signed char d = 5;
    signed char e = c;
    sprintf(buf, "%d %d %d", c, d, e);
    return strcmp(buf, "-3 5 -3");
}

static void check(void)
{
    nseen = 0;
    assertEqual(uconst(), 1 + 200 + 2 + 200);
    assertEqual(seen[0], 10 + 200);
    assertEqual(seen[1], 20 + 200);
    assertEqual(sconst(), 1 - 3 + 2 - 3);
    assertEqual(seen[2], 10 - 3);
    assertEqual(escaped(), 6 + 101);
    assertEqual(escaped_byte(), 5 + 9);
    assertEqual(viaptr(), 6 + 10);
    assertEqual(arr(), 130);
    assertEqual(reassigned(), 4 + 11);
    assertEqual(variadic(), 0);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("constant locals across calls");
    suite_add_test(check);
    return suite_run();
}
