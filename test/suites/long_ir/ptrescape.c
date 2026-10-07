/* [ast_cse] A write to a local whose address was taken changes what a pointer
 * to it reads, and a write through the pointer changes the local.
 *
 *  read_ptr   `a = *p; v = k + 7; b = *p;` returned the first read twice.
 *  read_local `a = v; *p = 5; b = v;` the same hole the other way round.
 *  read_ptr2  the write is a compound assignment.
 *  read_inc   the write is `v++`.
 *  read_glob  the written variable is a global.
 *  keep       nothing escapes: a repeated read with no write between is still
 *             one read (the control).
 */
#include "test.h"

static int read_ptr(int k)
{
    int v = k;
    int *p = &v;
    int a = *p;
    v = k + 7;
    int b = *p;
    return a * 100 + b;
}

static int read_local(int k)
{
    int v = k;
    int *p = &v;
    int a = v;
    *p = 5;
    int b = v;
    return a * 100 + b;
}

static int read_ptr2(int k)
{
    int v = k;
    int *p = &v;
    int a = *p + 1;
    v += 3;
    int b = *p + 1;
    return a * 100 + b;
}

static int read_inc(int k)
{
    int v = k;
    int *p = &v;
    int a = *p + 1;
    v++;
    int b = *p + 1;
    return a * 100 + b;
}

static int gv;

static int read_glob(int k)
{
    int *p = &gv;
    gv = k;
    int a = *p + 1;
    gv = k + 5;
    int b = *p + 1;
    return a * 100 + b;
}

static int keep(int k)
{
    int v = k;
    int a = v + 1;
    int b = v + 1;
    return a * 100 + b;
}

void test_ptrescape(void)
{
    assertEqual(read_ptr(10), 10 * 100 + 17);
    assertEqual(read_ptr(0), 7);
    assertEqual(read_local(10), 10 * 100 + 5);
    assertEqual(read_ptr2(10), 11 * 100 + 14);
    assertEqual(read_inc(10), 11 * 100 + 12);
    assertEqual(read_glob(10), 11 * 100 + 16);
    assertEqual(keep(4), 505);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("a write to an escaped local changes what a pointer reads");
    suite_add_test(test_ptrescape);
    return suite_run();
}
