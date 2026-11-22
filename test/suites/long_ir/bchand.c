/* A BC TENANT'S LAST READ CAN BE THE OP THAT DEFINES THE NEXT BC TEMP.
 *
 *     i = n++;  a[i] = x;  b[i] = y;
 *
 * `i` lives in BC and dies at the shift that produces `2*i`, which is then read
 * by both stores. The packer used to see the one op they share as an overlap,
 * left `2*i` in a frame slot and gave BC to a symbol address it could have
 * rebuilt for free. The shift reads `i` before the result is stamped into BC, so
 * the two now share the register across that op.
 *
 * Every case checks the stored data, so a clobbered BC (the doubled index
 * replaced mid-way) shows up as a wrong slot or a wrong value. The last cases
 * keep a value in BC across the hand-off point that must NOT be given away.
 */
#include "test.h"

static int na[8], nb[8], nc[8];
static char *names[8];
static void (*fns[8])(void);
static int cnt;

static void f0(void) {}

/* the framework's own registration shape */
static void add2(char *name, void (*fn)(void))
{
    int i;
    i = cnt++;
    names[i] = name;
    fns[i] = fn;
}

/* int arrays: the doubled index feeds two element addresses */
static void put2(int x, int y)
{
    int i;
    i = cnt++;
    na[i] = x;
    nb[i] = y;
}

/* three element stores off one index */
static void put3(int x, int y, int z)
{
    int i;
    i = cnt++;
    na[i] = x;
    nb[i] = y;
    nc[i] = z;
}

/* the index is read again after the doubled value is built */
static int put_ret(int x, int y)
{
    int i;
    i = cnt++;
    na[i] = x;
    nb[i] = y;
    return i;
}

/* loop: the index dies at the shift each iteration */
static int sum(int n)
{
    int i, s = 0;
    for (i = 0; i < n; i++)
        s += na[i] + nb[i];
    return s;
}

/* an address chain: base + 2*i, then + k, then the store */
static void chain(int i, int k, int v)
{
    int *p = &na[i];
    int *q = p + k;
    *q = v;
}

static void reset(void)
{
    int i;
    cnt = 0;
    for (i = 0; i < 8; i++) { na[i] = nb[i] = nc[i] = 0; names[i] = 0; fns[i] = 0; }
}

static void test_bchand(void)
{
    reset();
    add2("one", f0); add2("two", f0); add2("three", f0);
    assertEqual(cnt, 3);
    assertEqual(names[0][0], 'o'); assertEqual(names[1][0], 't');
    assertEqual(names[2][1], 'h');
    assertEqual(fns[0] == f0, 1); assertEqual(fns[2] == f0, 1);
    assertEqual(fns[3] == 0, 1);

    reset();
    put2(10, 20); put2(11, 21); put2(12, 22);
    assertEqual(na[0], 10); assertEqual(nb[0], 20);
    assertEqual(na[1], 11); assertEqual(nb[1], 21);
    assertEqual(na[2], 12); assertEqual(nb[2], 22);
    assertEqual(na[3], 0);  assertEqual(nb[3], 0);

    reset();
    put3(1, 2, 3); put3(4, 5, 6);
    assertEqual(na[0], 1); assertEqual(nb[0], 2); assertEqual(nc[0], 3);
    assertEqual(na[1], 4); assertEqual(nb[1], 5); assertEqual(nc[1], 6);

    reset();
    assertEqual(put_ret(7, 8), 0);
    assertEqual(put_ret(9, 10), 1);
    assertEqual(na[1], 9); assertEqual(nb[1], 10);

    reset();
    put2(3, 4); put2(5, 6); put2(7, 8);
    assertEqual(sum(3), 3 + 4 + 5 + 6 + 7 + 8);
    assertEqual(sum(1), 7);

    reset();
    chain(2, 3, 99);
    assertEqual(na[5], 99);
    chain(0, 1, 98);
    assertEqual(na[1], 98);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("BC hand-off between a dying tenant and the next temp");
    suite_add_test(test_bchand);
    return suite_run();
}
