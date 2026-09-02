/* Pre-pushed call args vs a BC-homed local (IR_PREPUSH_NARROW=0 opts out).
 *
 * A call whose args are pushed at their producers (CallInfo.pre_pushed) used to
 * disqualify EVERY non-param BC candidate in the whole function, on the grounds
 * that gen_call could not wrap such a call in push/pop bc. It can: gen_push_arg
 * emits `push bc` at the call's FIRST push — below the arg block — and gen_call
 * pops it after the cleanup. This pins what that save does and does not cover:
 *
 *  - live_across    the newly admitted shape: a write-once local live across a
 *                   pre-pushed scalar-arg call. The save/restore must carry it.
 *  - nested         f(a, g(b)) — the inner call's save/pop must pair LIFO with
 *                   the outer's, and BOTH locals must survive.
 *  - two_live       two locals live across the same call, so whichever wins BC
 *                   the other still reads its slot correctly.
 *  - struct_first   a by-value struct as the FIRST arg: it takes the first-push
 *                   slot, so NO save marker is emitted and the block copy (ldir)
 *                   eats BC with nothing to restore from. Must stay vetoed.
 *  - struct_second  a struct in second position IS covered by the save, but the
 *                   ldir still kills BC mid-group — so a later arg or a later
 *                   read inside the group cannot be served from BC. Also vetoed.
 *  - struct_middle  the mid-group hazard directly: a BC-homable local read as an
 *                   arg AFTER the struct push in the same call.
 *
 * Self-verifying with explicit constants under 16-bit arithmetic; no printf (it
 * perturbs allocation and can mask exactly this class of bug).
 */
#include "test.h"

typedef struct { unsigned int a, b, c; } Trip;

static unsigned int g_seq;

static unsigned int mix(unsigned int x, unsigned int y)
{
    g_seq = (unsigned int)(g_seq + 1u);
    return (unsigned int)(x * 3u + y);
}

static unsigned int eat_trip(Trip t, unsigned int k)
{
    g_seq = (unsigned int)(g_seq + 1u);
    return (unsigned int)(t.a + t.b + t.c + k);
}

static unsigned int trip_eat(unsigned int k, Trip t)
{
    g_seq = (unsigned int)(g_seq + 1u);
    return (unsigned int)(t.a + t.b + t.c + k);
}

static unsigned int trip_mid(unsigned int k, Trip t, unsigned int m)
{
    g_seq = (unsigned int)(g_seq + 1u);
    return (unsigned int)(t.a + t.b + t.c + k + m * 2u);
}

/* Write-once local, several uses, live across a pre-pushed scalar-arg call. */
static unsigned int live_across(unsigned int n)
{
    unsigned int keep = (unsigned int)(n + 100u);
    unsigned int acc = 0;
    unsigned int i;
    for (i = 0; i < 3u; i++)
        acc = (unsigned int)(acc + mix(keep, i));
    return (unsigned int)(acc + keep);
}

/* f(a, g(b)): the inner call's save must pair LIFO with the outer's. */
static unsigned int nested(unsigned int n)
{
    unsigned int outer = (unsigned int)(n + 10u);
    unsigned int inner = (unsigned int)(n + 20u);
    unsigned int r = mix(outer, mix(inner, 1u));
    return (unsigned int)(r + outer + inner);
}

/* Two locals live across the same call — one may take BC, the other must not
   be served from a stale BC after the call. */
static unsigned int two_live(unsigned int n)
{
    unsigned int p = (unsigned int)(n + 30u);
    unsigned int q = (unsigned int)(n + 40u);
    unsigned int r = mix(p, q);
    return (unsigned int)(r + p + q + p);
}

/* Struct pushed FIRST: no save marker, ldir eats BC. */
static unsigned int struct_first(unsigned int n)
{
    Trip t;
    unsigned int keep = (unsigned int)(n + 50u);
    unsigned int acc = 0;
    unsigned int i;
    t.a = n; t.b = (unsigned int)(n + 1u); t.c = (unsigned int)(n + 2u);
    for (i = 0; i < 2u; i++)
        acc = (unsigned int)(acc + eat_trip(t, keep));
    return (unsigned int)(acc + keep);
}

/* Struct pushed SECOND: the save fires, but the ldir still kills BC. */
static unsigned int struct_second(unsigned int n)
{
    Trip t;
    unsigned int keep = (unsigned int)(n + 60u);
    unsigned int acc = 0;
    unsigned int i;
    t.a = n; t.b = (unsigned int)(n + 1u); t.c = (unsigned int)(n + 2u);
    for (i = 0; i < 2u; i++)
        acc = (unsigned int)(acc + trip_eat(keep, t));
    return (unsigned int)(acc + keep);
}

/* A BC-homable local read as an argument AFTER the struct push in the same
   call — the mid-group hazard the save cannot help with. */
static unsigned int struct_middle(unsigned int n)
{
    Trip t;
    unsigned int keep = (unsigned int)(n + 70u);
    unsigned int acc = 0;
    unsigned int i;
    t.a = n; t.b = (unsigned int)(n + 1u); t.c = (unsigned int)(n + 2u);
    for (i = 0; i < 2u; i++)
        acc = (unsigned int)(acc + trip_mid(i, t, keep));
    return (unsigned int)(acc + keep);
}

static void test_prepush(void)
{
    g_seq = 0;

    /* keep=105; mix(105,i) = 315+i for i=0,1,2 -> 945+3 = 948; +105 = 1053 */
    assertEqual(live_across(5), 1053u);
    assertEqual(g_seq, 3u);

    /* outer=15 inner=25; mix(25,1)=76; mix(15,76)=121; +15+25 = 161 */
    g_seq = 0;
    assertEqual(nested(5), 161u);
    assertEqual(g_seq, 2u);

    /* p=35 q=45; mix(35,45)=150; +35+45+35 = 265 */
    g_seq = 0;
    assertEqual(two_live(5), 265u);
    assertEqual(g_seq, 1u);

    /* t = 5,6,7 (sum 18); keep=55; eat_trip = 18+55 = 73, twice -> 146; +55 = 201 */
    g_seq = 0;
    assertEqual(struct_first(5), 201u);
    assertEqual(g_seq, 2u);

    /* keep=65; trip_eat = 18+65 = 83, twice -> 166; +65 = 231 */
    g_seq = 0;
    assertEqual(struct_second(5), 231u);
    assertEqual(g_seq, 2u);

    /* keep=75; trip_mid(i,t,75) = 18+i+150 -> i=0:168, i=1:169 = 337; +75 = 412 */
    g_seq = 0;
    assertEqual(struct_middle(5), 412u);
    assertEqual(g_seq, 2u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Pre-pushed args vs a BC-homed local");
    suite_add_test(test_prepush);
    return suite_run();
}
