/* A word compared with -1, and a word minus a constant, across the values
 * around the edges of the range. */
#include "test.h"

int g;

static int is_m1(int x)            { return x == -1; }
static int not_m1(int x)           { return x != -1; }
static int br_m1(int x)            { if (x == -1) return 10; return 20; }
static int br_nm1(int x)           { if (x != -1) return 10; return 20; }
static int um1(unsigned x)         { return x == 65535u; }
static int glob_m1(void)           { return g == -1; }
static int loop_m1(int *p)         { int n = 0; while (*p != -1) { n++; p++; } return n; }
static int sub10(int x)            { return x - 10; }
static int sub300(int x)           { return x - 300; }
static int sub_min(int x)          { return x - 32768; }
static int sub_ptr(char *p)        { return (int)(p - (char *)100); }

static void check(void)
{
    int v[8] = { 0, 1, -1, 255, -256, 32767, -32768, 0x7fff };
    int i, tab[5];

    for (i = 0; i < 8; i++) {
        int x = v[i];
        assertEqual(is_m1(x), x == -1);
        assertEqual(not_m1(x), x != -1);
        assertEqual(br_m1(x), ((x == -1) ? 10 : 20));
        assertEqual(br_nm1(x), ((x != -1) ? 10 : 20));
        assertEqual(um1((unsigned)x), (unsigned)x == 65535u);
        g = x;
        assertEqual(glob_m1(), x == -1);
        assertEqual(sub10(x), (int)(x - 10));
        assertEqual(sub300(x), (int)(x - 300));
        assertEqual(sub_min(x), (int)(x ^ -32768));
    }
    tab[0] = 4; tab[1] = 0; tab[2] = -2; tab[3] = 255; tab[4] = -1;
    assertEqual(loop_m1(tab), 4);
    assertEqual(sub_ptr((char *)150), 50);
    assertEqual(sub_ptr((char *)90), -10);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("word compare with -1 and word minus constant");
    suite_add_test(check);
    return suite_run();
}
