#include "test.h"
#include <stdlib.h>

/* A statement __critical restores the interrupt state when break,
   continue, goto, or return leaves it. A transfer that stays inside
   the statement does not. Nested statement __critical is not here.
   The returned numbers do not show the flag. On a cpu where ld a,i
   copies IFF2 into P/V, read_iff checks that flag. On the 8085,
   read_iff checks bit 3 of the RIM byte. */

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

/* The local is above the saved flag word. Leave pops the local, then
   the word. */
static int local_out(int n)
{
    int s;

    s = 0;
    __critical {
        int t;

        t = n + 1;
        s = t;
        if (n)
            goto out;
    }
    s += 5;
out:
    return s;
}

/* Two forward gotos share one label. One is outside the block. */
static int twodepth(int n)
{
    int s;

    s = 1;
    if (n == 0)
        goto join;
    __critical {
        s = 3;
        if (n == 1)
            goto join;
        s = 9;
    }
join:
    return s;
}

/* The switch body is buffered. The goto leaves the block for a later case. */
static int swlater(int n)
{
    int s;

    s = 0;
    switch (n) {
    case 0:
        __critical {
            s = 4;
            goto later;
        }
        break;
    case 1:
        s = 10;
        break;
    case 2:
later:
        s += 20;
        break;
    }
    return s;
}

/* The open inner block puts the second enter at a different stack
   position. Both sites are the same depth. The goto keeps the first
   enter and the second leave pops that word. */
static int cross(int n)
{
    int r;

    r = 0;
    __critical {
        int t;

        t = 1;
        r = t;
        if (n)
            goto other;
        r = 2;
    }
    {
        int gap;

        gap = 3;
        __critical {
        other:
            r = r + 10;
        }
    }
    return r;
}

/* The label is already defined, and it sits below a local. */
static int cross_back(int n)
{
    int r;

    r = 0;
    if (n)
        goto start;
    {
        int gap;

        gap = 5;
        __critical {
            int u;

        other:
            u = 7;
            r = r + u;
            goto done;
        }
    }
start:
    __critical {
        int t;

        t = 1;
        r = t;
        goto other;
    }
done:
    return r;
}

/* The goto leaves the inner block for a shallower enter. */
static int cross_up(int n)
{
    int r;

    r = 0;
    {
        int gap;

        gap = 3;
        __critical {
            int t;

            t = 1;
            r = t;
            if (n)
                goto other;
            r = 2;
        }
    }
    __critical {
    other:
        r = r + 10;
    }
    return r;
}

#if defined(__Z80__) || defined(__Z180) || defined(__Z180__) || defined(__EZ80_Z80) || defined(__EZ80_Z80__) || defined(__KC160_Z80) || defined(__KC160_Z80__) || defined(__8085)
/* A set enable returns 4. A clear enable returns 0.
   ld a,i copies IFF2 into P/V, and P/V is bit 2.
   RIM bit 3 is the 8085 enable. and 8 makes the same 4 or 0. */
static int read_iff(void) __naked
{
#if defined(__8085)
#asm
    rim
    and 8
    ld hl,0
    jp z, read_iff_off
    ld hl,4
read_iff_off:
    ret
#endasm
#else
#asm
    ld a,i
    ld hl,0
    jp po, read_iff_off
    ld hl,4
read_iff_off:
    ret
#endasm
#endif
}

static int iff_brk(void)
{
    int inside;

    asm("ei");
    while (1) {
        __critical {
            inside = read_iff();
            break;
        }
    }
    return inside + read_iff();
}

static int iff_cont(void)
{
    int i;
    int inside;

    asm("ei");
    for (i = 0; i < 1; i++) {
        __critical {
            inside = read_iff();
            continue;
        }
    }
    return inside + read_iff();
}

static int iff_goto(void)
{
    int inside;

    asm("ei");
    __critical {
        inside = read_iff();
        goto iff_out;
    }
iff_out:
    return inside + read_iff();
}

static int iff_case(void)
{
    int inside;

    asm("ei");
    switch (1) {
    case 1:
        __critical {
            inside = read_iff();
            break;
        }
        break;
    }
    return inside + read_iff();
}

/* The break stays inside the block, so the flag stays clear until the end. */
static int iff_stay(void)
{
    int mid;

    asm("ei");
    __critical {
        while (1)
            break;
        mid = read_iff();
    }
    return mid + read_iff();
}

static int iff_cross(void)
{
    int inside;

    asm("ei");
    __critical {
        int t;

        t = 1;
        inside = read_iff();
        goto other;
    }
    {
        int gap;

        gap = 3;
        __critical {
        other:
            ;
        }
    }
    return inside + read_iff();
}

static int iff_cross_back(void)
{
    int inside;

    asm("ei");
    goto start;
    {
        int gap;

        gap = 5;
        __critical {
        other:
            inside = read_iff();
            goto done;
        }
    }
start:
    __critical {
        int t;

        t = 1;
        goto other;
    }
done:
    return inside + read_iff();
}
#endif

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
    assertEqual(local_out(3), 4);
    assertEqual(local_out(0), 6);
    assertEqual(twodepth(0), 1);
    assertEqual(twodepth(1), 3);
    assertEqual(twodepth(2), 9);
    assertEqual(swlater(0), 24);
    assertEqual(swlater(1), 10);
    assertEqual(swlater(2), 20);
    assertEqual(cross(1), 11);
    assertEqual(cross(0), 12);
    assertEqual(cross_back(1), 8);
    assertEqual(cross_back(0), 7);
    assertEqual(cross_up(1), 11);
    assertEqual(cross_up(0), 12);
#if defined(__Z80__) || defined(__Z180) || defined(__Z180__) || defined(__EZ80_Z80) || defined(__EZ80_Z80__) || defined(__KC160_Z80) || defined(__KC160_Z80__) || defined(__8085)
    assertEqual(iff_brk(), 4);
    assertEqual(iff_cont(), 4);
    assertEqual(iff_goto(), 4);
    assertEqual(iff_case(), 4);
    assertEqual(iff_stay(), 4);
    assertEqual(iff_cross(), 4);
    assertEqual(iff_cross_back(), 4);
#endif
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
