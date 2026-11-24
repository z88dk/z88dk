/* Statement __critical on a save CPU. The interrupt word is pushed in
   the body. These checks cover each way out of the statement, a loop
   counter, values live across the helper call, and parameter offsets
   with that word on the stack.

   A longjmp out of the statement does not pass a leave. Interrupts
   stay as the block left them, and a save CPU leaves the status word
   on the stack. The same is true of any transfer the CFG does not
   name. A leave on each IR edge cannot see it. Both compilers.

   A goto, break, or continue that this compiler's CFG names does get
   a leave. sccz80 does not restore on break or continue out of a
   statement __critical, and it does not restore on goto either.

   Inline asm that pushes or pops inside the statement moves the
   status word. The leave then restores the wrong value. sccz80 has
   the same hole. The builder does not see those pushes. */
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

/* Parameters only. The statement word sits under them. */
static int bare(int a, long b)
{
    __critical { return a + (int)b; }
}

struct two {
    int a;
    int b;
};

static int byval(struct two s)
{
    __critical { return s.a * 10 + s.b; }
}

static int seq(int n)
{
    int s = n;

    __critical { s += 1; }
    __critical { s += 10; }
    return s;
}

static int seqfn(int n) __critical
{
    int s = n;

    __critical { s += 1; }
    __critical { s += 10; }
    return s;
}

static int join(int n)
{
    int s = 100;

    if (n) {
        __critical {
            s += n;
            goto out;
        }
    } else {
        __critical {
            s += 3;
            goto out;
        }
    }
out:
    return s;
}

static int triple(int a, int b, int c)
{
    int x = a;
    int y = b;
    int z = c;

    __critical {
        x += 1;
        y += 2;
        z += 3;
    }
    return x + y + z;
}

/* Nested statement. A save CPU pushes two words. A flagless CPU emits
   one di/ei, or one ipset/ipres, for the outer statement. */
static int nestcrit(int n)
{
    volatile int s = n;
    int t = 3;

    __critical {
        s += t;
        __critical { s += n; }
    }
    return s;
}

static int volstore(int n)
{
    volatile int v = 0;

    __critical { v = n + 1; }
    return v;
}

/* Fall-through keeps the word until the switch arm leaves the block. */
static int swfall(int n)
{
    int s = 100;

    __critical {
        switch (n) {
        case 1:
            s += 1;
        case 2:
            s += 2;
            break;
        case 3:
            s = 104;
            break;
        default:
            break;
        }
    }
    return s;
}

static int dobreak(int n)
{
    int s = 0;

    do {
        __critical {
            s++;
            if (s >= 4) break;
        }
    } while (s < n);
    return s;
}

static int nestloops(int n)
{
    int s = 100;
    int i;
    int j;

    for (i = 0; i < n; i++) {
        for (j = 0; j < 2; j++) {
            __critical { s++; }
        }
    }
    return s;
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
    assertEqual(bare(6, 9L), 15);
    {
        struct two s;

        s.a = 3;
        s.b = 4;
        assertEqual(byval(s), 34);
    }
    assertEqual(seq(6), 17);
    assertEqual(seqfn(6), 17);
    assertEqual(join(7), 107);
    assertEqual(join(0), 103);
    assertEqual(triple(4, 5, 6), 21);
    assertEqual(nestcrit(6), 15);
    assertEqual(volstore(6), 7);
    assertEqual(swfall(1), 103);
    assertEqual(swfall(2), 102);
    assertEqual(swfall(3), 104);
    assertEqual(swfall(0), 100);
    assertEqual(dobreak(9), 4);
    assertEqual(dobreak(2), 2);
    assertEqual(nestloops(0), 100);
    assertEqual(nestloops(1), 102);
    assertEqual(nestloops(2), 104);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Statement __critical");
    suite_add_test(test_critstmt);
    return suite_run();
}
