/* A JUMP TO THE LABEL BELOW IT IS DEAD.
 *
 * 80cc emits the shared return block last, so the block just above it ends
 * `jp L_ret` directly over `L_ret:`; tail merging and block layout produce the
 * same adjacency elsewhere. A fall-through is identical control flow in no
 * bytes, so the jump is removed in the final text.
 *
 * The functions below each end a branch arm with a call (so nothing folds the
 * jump away earlier) and then join. The last cases keep a jump that is NOT
 * adjacent to its target and must stay.
 */
#include "test.h"

static int hits;
static void note(int n) { hits = hits * 10 + n; }

/* arm ends in a call, then joins at the return */
static int early(int x)
{
    if (x < 0) { note(1); return -1; }
    if (x == 0) { note(2); }
    else        { note(3); }
    return x;
}

/* every arm calls, then all join on one return value */
static int sw(int k)
{
    int r = 0;
    switch (k) {
    case 1: note(1); r = 10; break;
    case 2: note(2); r = 20; break;
    case 3: note(3); r = 30; break;
    default: note(9); r = -1; break;
    }
    return r;
}

/* loop with an early exit through a call */
static int scan(const int *p, int n)
{
    int i;
    for (i = 0; i < n; i++) {
        if (p[i] == 0) { note(4); break; }
    }
    return i;
}

/* goto to a label that is the next statement, and a goto that skips code */
static int gotos(int x)
{
    if (x) goto done;
    note(5);
done:
    return x + 1;
}

static int skip(int x)
{
    if (x) goto end;
    note(6);
    note(7);
end:
    return x;
}

/* void function ending in a call on both arms */
static void vend(int c) { if (c) note(1); else note(2); }

static void test_jpnext(void)
{
    hits = 0; assertEqual(early(-5), -1); assertEqual(hits, 1);
    hits = 0; assertEqual(early(0), 0);   assertEqual(hits, 2);
    hits = 0; assertEqual(early(7), 7);   assertEqual(hits, 3);

    hits = 0; assertEqual(sw(1), 10); assertEqual(hits, 1);
    hits = 0; assertEqual(sw(3), 30); assertEqual(hits, 3);
    hits = 0; assertEqual(sw(8), -1); assertEqual(hits, 9);

    {
        static const int a[5] = { 3, 2, 0, 1, 4 };
        static const int b[3] = { 1, 2, 3 };
        hits = 0; assertEqual(scan(a, 5), 2); assertEqual(hits, 4);
        hits = 0; assertEqual(scan(b, 3), 3); assertEqual(hits, 0);
    }

    hits = 0; assertEqual(gotos(0), 1); assertEqual(hits, 5);
    hits = 0; assertEqual(gotos(4), 5); assertEqual(hits, 0);
    hits = 0; assertEqual(skip(0), 0);  assertEqual(hits, 67);
    hits = 0; assertEqual(skip(9), 9);  assertEqual(hits, 0);

    hits = 0; vend(1); vend(0); assertEqual(hits, 12);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("A jump to the label below it is dead");
    suite_add_test(test_jpnext);
    return suite_run();
}
