/* [IR_IDX2BASE] A deref base may take the spare index register.
 *
 * It used to be rejected outright (`if (is_base[v]) return 0;` in
 * idx2_home_realizable), so a struct pointer could never reach an index home
 * however well it scored, while a scalar param read through `push iy;pop hl`
 * could. That is backwards: IX/IY cannot feed the ALU, so a scalar pays on
 * every read where a base pays nothing — (iy+d) IS the access. bitfieldbench's
 * reg_set showed it: the VALUE got IY and the POINTER was spilled.
 *
 * The half that MUST FIRE:
 *   field_sum / field_set — a read-only struct-pointer param dereffed at
 *   several fixed offsets. That is the shape (iy+d) serves.
 *
 * walk_sum is a STEPPED pointer, which IDX2_BASE_STEPPED keeps out of the
 * index home. ►► BE CLEAR WHAT THIS TEST CAN AND CANNOT PIN: that guard is
 * ECONOMIC, not a correctness guard. Removing it was verified to leave this
 * test PASSING — the lowering handles a stepped base in IY correctly, it just
 * costs more (+19 B on strbench, which is why the guard exists). Only the
 * corpus size scan can catch a regression there.
 *
 * What this test DOES pin is that the new allocation path is CORRECT: with a
 * deref base homed in the spare index register, the field reads and writes
 * still produce the right values. That path did not exist before IR_IDX2BASE.
 *
 * Note also that the small functions below (field_sum/field_set) do NOT reach
 * the gate at all — their pointer lands in BC, and idx2_home_realizable
 * requires IR_PR_SPILL. They are kept as the control; bf_set/bf_get are the
 * shape that actually exercises it (82 lines of gate-on/gate-off asm diff).
 *
 * Constants derived independently; no printf (it perturbs allocation).
 */
#include "test.h"

#define bf_expect 2318u   /* derived independently, 16-bit modular */

struct rec { int a, b, c, d; };

/* reg_set's shape, and the only one that actually reaches the gate: enough
   field traffic against one pointer that BC and DE are taken and the pointer
   would otherwise SPILL — idx2_home_realizable requires IR_PR_SPILL, so a
   function small enough for the pointer to land in BC never exercises this at
   all (field_sum below is exactly that case, and is kept as the control). */
struct bf { unsigned mode:3; unsigned chan:5; unsigned rate:12;
            unsigned flag:1; unsigned level:7; unsigned spare:4; };

static struct bf bfs[4];

static void bf_set(struct bf *r, unsigned int v)
{
    r->mode  = v & 7u;
    r->chan  = (v >> 3) & 31u;
    r->rate  = (v >> 4) & 4095u;
    r->flag  = (v >> 1) & 1u;
    r->level = (v >> 6) & 127u;
}

static unsigned int bf_get(const struct bf *r)
{
    unsigned int acc = 0;
    acc = (unsigned int)(acc + r->mode);
    acc = (unsigned int)(acc + (r->chan << 1));
    acc = (unsigned int)(acc + r->rate);
    acc = (unsigned int)(acc + (r->flag << 5));
    acc = (unsigned int)(acc + (r->level << 2));
    return acc & 0xffffu;
}

static struct rec recs[6];

/* read-only pointer param, four fixed-offset derefs */
static int field_sum(const struct rec *r)
{
    return r->a + r->b + r->c + r->d;
}

/* read-only pointer param, fixed-offset WRITES — reg_set's shape: a second
   live param (the value) competes for the spare index register, which is the
   contention the gate resolves. */
static void field_set(struct rec *r, int base)
{
    r->a = base;
    r->b = base + 1;
    r->c = base + 2;
    r->d = base + 3;
}

/* More field traffic against one pointer, so the pointer is the clear
   index-home candidate and the scalar is not. */
static void field_mix(struct rec *r, int v)
{
    r->a = v & 0xff;
    r->b = (v >> 2) & 0x3f;
    r->c = (v >> 4) & 0x0f;
    r->d = (v >> 6) & 0x03;
}

/* STEPPED pointer — must stay out of the index home */
static int walk_sum(const int *p, int n)
{
    int s = 0;
    while (n--) s += *p++;
    return s;
}

static void test_idxbase(void)
{
    int i, s = 0;
    for (i = 0; i < 6; i++) field_set(&recs[i], i * 10);
    for (i = 0; i < 6; i++) s += field_sum(&recs[i]);
    /* field_set(i*10) gives a..d = 10i, 10i+1, 10i+2, 10i+3; sum = 40i + 6.
       Over i = 0..5: 40*(0+1+2+3+4+5) + 6*6 = 600 + 36 = 636. */
    assertEqual(s, 636);

    /* the stepped walk over the same storage: recs is 6 x 4 ints, and the
       values are 10i+0..3 laid out consecutively, so the total is the same. */
    assertEqual(walk_sum(&recs[0].a, 24), 636);
    /* a partial walk, so a wrong step size shows as a wrong sum rather than
       coincidentally matching the whole-array total */
    assertEqual(walk_sum(&recs[0].a, 5), 0 + 1 + 2 + 3 + 10);

    {   unsigned int acc = 0; int k;
        for (k = 0; k < 4; k++) bf_set(&bfs[k], (unsigned int)(k * 4241u + 7u));
        for (k = 0; k < 4; k++) acc = (unsigned int)(acc + bf_get(&bfs[k]));
        assertEqual(acc, bf_expect);
    }

    field_mix(&recs[0], 0x5AA5);
    /* 0x5AA5 = 0101 1010 1010 0101 */
    assertEqual(recs[0].a, 0xA5);
    assertEqual(recs[0].b, (0x5AA5 >> 2) & 0x3f);
    assertEqual(recs[0].c, (0x5AA5 >> 4) & 0x0f);
    assertEqual(recs[0].d, (0x5AA5 >> 6) & 0x03);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("deref base in the spare index register");
    suite_add_test(test_idxbase);
    return suite_run();
}
