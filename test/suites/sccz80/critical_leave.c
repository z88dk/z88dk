#include "test.h"
#include <stdlib.h>

/* A statement __critical restores the interrupt state when break,
   continue, goto, or return leaves it. A transfer that stays inside
   the statement does not. Nested statement __critical is not here. */

static int plus(int a, int b)
{
    return a + b;
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

static int cont_out(int n)
{
    int s = 0;
    int i;

    for (i = 0; i < n; i++) {
        __critical {
            if (i < 2) continue;
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

static int stay(int n)
{
    int s = 0;

    __critical {
        while (n > 0) {
            s += n;
            break;
        }
        s += 5;
    }
    return s;
}

static int cstay(int n)
{
    int s = 0;
    int i;

    __critical {
        for (i = 0; i < n; i++) {
            if (i == 1) continue;
            s += i;
        }
    }
    return s;
}

static int gin(void)
{
    int s = 0;

    __critical {
        goto in;
        s = 1;
    in:
        s = 4;
    }
    return s;
}

static int casebrk(int n)
{
    int s = 0;

    switch (n) {
    case 1:
        __critical {
            s = 3;
            break;
        }
        s = 9;
        break;
    default:
        s = 1;
        break;
    }
    return s;
}

static int callout(int n)
{
    int s = 0;

    while (n) {
        __critical {
            s = plus(s, 1);
            if (s == 3) break;
        }
        n--;
    }
    return s;
}

static int fnbrk(int n) __critical
{
    int s = 0;

    while (n--) {
        __critical {
            s++;
            if (s == 2) break;
        }
    }
    return s;
}

static int fngoto(int n) __critical
{
    int s = 0;

    __critical {
        s = n;
        if (n) goto out;
        s = 4;
    }
    s += 1;
out:
    return s;
}

static int fnstay(int n) __critical
{
    int s = 0;
    int i;

    __critical {
        for (i = 0; i < n; i++) {
            if (i == 1) continue;
            s += i;
        }
    }
    return s;
}

static void test_leave(void)
{
    assertEqual(brk(6), 3);
    assertEqual(rcont(6), 15);
    assertEqual(cont_out(5), 9);
    assertEqual(gout(6), 8);
    assertEqual(swgoto(1), 207);
    assertEqual(swgoto(2), 233);
    assertEqual(swgoto(0), 226);
    assertEqual(cdbr(4), 9);
    assertEqual(stay(4), 9);
    assertEqual(cstay(4), 5);
    assertEqual(gin(), 4);
    assertEqual(casebrk(1), 3);
    assertEqual(casebrk(0), 1);
    assertEqual(callout(9), 3);
    assertEqual(fnbrk(5), 2);
    assertEqual(fngoto(3), 3);
    assertEqual(fngoto(0), 5);
    assertEqual(fnstay(4), 5);
}

int suite_critical_leave(void)
{
    suite_setup("Critical leave");
    suite_add_test(test_leave);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    (void)argc;
    (void)argv;
    res += suite_critical_leave();
    exit(res);
}
