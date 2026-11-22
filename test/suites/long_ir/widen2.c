/* Narrow values widened into an int must extend by their OWN signedness.
 *
 * Two sites dropped the conversion entirely and let the lowerer zero-fill the
 * high half:
 *
 *   1. The DECL-INITIALISER path (`int a = gs;`) emitted a bare MOV from the
 *      narrower vreg. The equivalent assignment to a GLOBAL int was correct
 *      because that path converges widths; only the local initialiser did not.
 *   2. The COMPOUND-ASSIGN path (`acc += x`) converged operand widths only
 *      when the destination was width 4, so a width-2 accumulator with a
 *      byte RHS produced a MIXED-width ADD.
 *
 * Both zero-extended, so only NEGATIVE narrow values expose them —
 * `signed char gs = -56; int a = gs;` gave 200, and
 * `acc += (signed char)(u ^ 0x80u)` added 186 instead of -70. Every case
 * below therefore uses a value with bit 7 set, and both signednesses are
 * checked so the fix cannot simply sign-extend everything.
 */
#include "test.h"

signed char   gs = -56;      /* 0xC8 */
unsigned char gu = 200;      /* 0xC8, same bits, opposite meaning */
static signed char   sarr[4] = { -56, -1, 91, 0 };
static unsigned char uarr[4] = { 200, 255, 91, 0 };

static int addto(int acc, int k)
{
    signed char   s = sarr[k & 3];
    unsigned char u = uarr[k & 3];
    acc += s;                          /* sign-extend */
    acc += u;                          /* zero-extend */
    acc += (signed char)(u ^ 0x80u);   /* cast then widen, negative result */
    return acc;
}

static void test_widen2(void)
{
    /* 1. decl initialiser vs assignment, global source, both signednesses */
    {
        int a = gs;  int b = gu;
        int c;       int d;
        c = gs;      d = gu;
        assertEqual(a, -56);
        assertEqual(b, 200);
        assertEqual(c, -56);
        assertEqual(d, 200);
    }
    /* 2. explicit cast and a local source still agree */
    {
        signed char ls = -56;
        int e = (int)gs;
        int f = ls;
        int g = (signed char)gu;
        assertEqual(e, -56);
        assertEqual(f, -56);
        assertEqual(g, -56);
    }
    /* 3. compound assign into a width-2 accumulator */
    {
        int acc = 0;
        acc += gs;                      /* -56 */
        assertEqual(acc, -56);
        acc += gu;                      /* +200 */
        assertEqual(acc, 144);
        acc -= gs;                      /* +56 */
        assertEqual(acc, 200);
    }
    /* 4. the array/parameter shape, where the accumulator is a parameter */
    assertEqual(addto(0, 0), -56 + 200 + 72);   /* 200^128 = 72, positive */
    assertEqual(addto(0, 1), -1 + 255 + 127);   /* 255^128 = 127 */
    assertEqual(addto(0, 2), 91 + 91 + (-37));  /*  91^128 = 219 -> -37 */
    assertEqual(addto(100, 2), 100 + 91 + 91 + (-37));

    /* 5. width-4 destination still converges (the case that already worked) */
    {
        long l = 0;
        l += gs;
        assertEqual(l == -56L, 1);
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Narrow-to-int widening keeps its own signedness");
    suite_add_test(test_widen2);
    return suite_run();
}
