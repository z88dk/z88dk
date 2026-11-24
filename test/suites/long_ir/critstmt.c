/* Statement __critical on a save CPU. The interrupt word is pushed in
   the body. These checks cover each way out of the statement, a loop
   counter, and values live across the helper call. */
#include "test.h"

static int sink;

static int retin(int a)
{
    __critical {
        if (a) return a + 1;
    }
    return 0;
}

static int retonly(void)
{
    __critical { return 4; }
    return 0;
}

static int retaft(int a)
{
    int x;

    __critical { x = a + 1; }
    return x;
}

static int brk(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            s++;
            if (s == 3) break;
        }
    }
    return s;
}

static int rcont(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            if (i == 0) continue;
            s += i;
        }
    }
    return s;
}

static int gout(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            s += 2;
            if (s > 6) goto out;
        }
    }
out:
    return s;
}

static int swgoto(int n)
{
    int s = 200;

    __critical {
        switch (n) {
        case 2:
            s += 10;
            break;
        case 1:
            goto out;
        default:
            s += 3;
            break;
        }
        s += 20;
    }
out:
    if (n == 1) return s + 7;
    return s + 3;
}

static int fused(const int *p, int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            if (p[i] != 0) s++;
        }
    }
    return s;
}

static int cdbr(int n)
{
    int s = 0;

    while (n > 0) {
        __critical {
            if (n == 1) break;
            s += n;
        }
        n--;
    }
    return s;
}

static int kcount(int n)
{
    int s = 0;

    while (n--)
        __critical { s++; }
    return s;
}

static int f1(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical { s++; }
    }
    return s;
}

static int f1_plain(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) s++;
    return s;
}

static int f1_fn(int n) __critical
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) s++;
    return s;
}

static int f_down(int n)
{
    int s = 0;

    while (n > 0) {
        __critical { s++; }
        n--;
    }
    return s;
}

static int f_three(void)
{
    int k = 0;
    int i;

    for (i = 0; i < 3; i++) {
        __critical { k++; }
    }
    return k;
}

static int f_odd(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            if (i & 1) s += 2;
            else s++;
        }
    }
    return s;
}

static int deacc(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        s += i;
        __critical { sink = i; }
    }
    return s;
}

static int mix(int a, int b)
{
    int x = a;
    int y = a + 1;

    __critical { y += b; }
    return x + y;
}

static int inn(int a) __critical
{
    int s = a;

    __critical { s += 3; }
    return s;
}

static int id(int x)
{
    return x + 1;
}

static int callbef(int n)
{
    int s = id(n);

    __critical { s += 2; }
    return s;
}

static int callin(int n)
{
    int s = 0;

    __critical { s = id(n); }
    return s;
}

static int callaft(int n)
{
    int s = n;

    __critical { s += 3; }
    return id(s);
}

static int callloop(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical { s += id(i); }
    }
    return s;
}

static int search(const int *p, int n, int key)
{
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            if (p[i] == key) return i;
        }
    }
    return -1;
}

static void test_critstmt(void)
{
    static const int row[4] = { 0, 4, 0, 1 };

    assertEqual(retin(6), 7);
    assertEqual(retin(0), 0);
    assertEqual(retonly(), 4);
    assertEqual(retaft(6), 7);
    assertEqual(brk(6), 3);
    assertEqual(rcont(6), 15);
    assertEqual(gout(6), 8);
    assertEqual(swgoto(1), 207);
    assertEqual(swgoto(2), 233);
    assertEqual(swgoto(0), 226);
    assertEqual(fused(row, 4), 2);
    assertEqual(cdbr(4), 9);
    assertEqual(kcount(6), 6);
    assertEqual(f1(6), 6);
    assertEqual(f1_plain(6), 6);
    assertEqual(f1_fn(6), 6);
    assertEqual(f_down(3), 3);
    assertEqual(f_three(), 3);
    assertEqual(f_odd(6), 9);
    assertEqual(deacc(6), 15);
    assertEqual(sink, 5);
    assertEqual(mix(6, 9), 22);
    assertEqual(inn(4), 7);
    assertEqual(callbef(6), 9);
    assertEqual(callin(6), 7);
    assertEqual(callaft(6), 10);
    assertEqual(callloop(6), 21);
    assertEqual(search(row, 4, 4), 1);
    assertEqual(search(row, 4, 9), -1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Statement __critical");
    suite_add_test(test_critstmt);
    return suite_run();
}
