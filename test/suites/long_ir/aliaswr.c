/* [cse / cse-synth / licm] A write through a POINTER names no symbol.
 *
 * adr/0082 fixed `ir_opt_const_fold`, whose belief about a local's value was
 * cleared only by a REDEFINITION of that local. The same hole was open in
 * four more places, and two of them were wrong on plain C with no address of
 * a local in sight:
 *
 *  - ind_ptr   `*p = a + x; t = a + x;` returned THE POINTER. ast_cse read
 *              OP_ASSIGN's `(deref (lv=p))` destination as "a write of p"
 *              (the spelling a COMPOUND assignment uses for `p += …`), then
 *              recorded the stored expression against p, so the next
 *              occurrence was substituted with p's value. Was &slot, must be 7.
 *  - ind_stale the other half of the same misreading: the store invalidated
 *              p and left every belief about what p POINTS AT standing.
 *              `t1 = a + x; *p = 5; t2 = a + x;` — was 55, must be 58.
 *  - call_esc  ir_opt_cse's table is invalidated by a vreg write, and a call
 *              handed a local's address writes the local's SLOT without
 *              redefining any vreg. Was 55, must be 56. (A constant
 *              initialiser hides this one: const-fold rewrites the first ADD
 *              to an immediate form that no longer matches the second.)
 *  - synth_glob ast_cse_synthesize hoisted a shared subexpression over an
 *              indirect store, because its invalidation asked only whether a
 *              statement DIRECTLY writes a sym the candidate reads. Was 1111,
 *              must be 1121.
 *  - licm_esc  ast_licm hoisted a loop-invariant over an indirect store in
 *              the body, for the same reason. Was 27, must be 54.
 *
 * The controls pin the half that must keep working: a write to a bare local
 * still invalidates only that local (keep_cse), and a compound assignment's
 * `(deref (lv=a))` destination still means a itself, not an indirect store
 * (keep_compound).
 */
#include "test.h"

static unsigned int slot;
static unsigned int g1 = 3, g2 = 5;
static unsigned int o1, o2;

static void bump(unsigned int *q) { *q += 1u; }

/* The stored expression must not be recorded against the pointer. */
static unsigned int ind_ptr(unsigned int *p, unsigned int a, unsigned int x)
{
    unsigned int t;

    *p = (unsigned int)(a + x);
    t = (unsigned int)(a + x);
    return t;
}

/* The store must clear what is believed about the pointed-at local. */
static unsigned int ind_stale(unsigned int x)
{
    unsigned int a = 2;
    unsigned int *p = &a;
    unsigned int t1, t2;

    t1 = (unsigned int)(a + x);
    *p = 5;
    t2 = (unsigned int)(a + x);
    return (unsigned int)((t1 * 10u + t2) & 0xffffu);
}

/* A call holding the local's address writes its slot. */
static unsigned int call_esc(unsigned int seed, unsigned int x)
{
    unsigned int a = seed;          /* non-constant: const-fold can't mask it */
    unsigned int t1, t2;

    t1 = (unsigned int)(a + x);
    bump(&a);
    t2 = (unsigned int)(a + x);
    return (unsigned int)((t1 * 10u + t2) & 0xffffu);
}

/* Synthesis must not hoist a subexpression over an indirect store. */
static unsigned int synth_glob(unsigned int x)
{
    unsigned int *p = &g1;
    unsigned int t1, t2;

    g1 = 3; g2 = 5;
    t1 = (unsigned int)(g1 * x + g2);
    *p = 8;
    t2 = (unsigned int)(g1 * x + g2);
    return (unsigned int)((t1 * 100u + t2) & 0xffffu);
}

/* LICM must not hoist a loop invariant over an indirect store. */
static unsigned int licm_esc(unsigned int x)
{
    unsigned int a = 1;
    unsigned int *p = &a;
    unsigned int s = 0;
    int k;

    for (k = 0; k < 3; k++) {
        s = (unsigned int)(s + a * x + a * 7u);
        *p = (unsigned int)(a + 1u);
    }
    return s;
}

/* Control: a write to a bare local invalidates that local and nothing else,
   so the second `b + x` is still free to reuse the first. Pinned by value. */
static unsigned int keep_cse(unsigned int x)
{
    unsigned int a = 1, b = 2;
    unsigned int t1, t2;

    t1 = (unsigned int)(b + x);
    a = 9;
    t2 = (unsigned int)(b + x);
    return (unsigned int)((t1 * 10u + t2 + a) & 0xffffu);
}

/* Control: `a += k` writes a itself — its `(deref (lv=a))` destination must
   not be read as a store through a. */
static unsigned int keep_compound(unsigned int x)
{
    unsigned int a = 4;
    unsigned int t1, t2;

    t1 = (unsigned int)(a + x);
    a += 3u;
    t2 = (unsigned int)(a + x);
    return (unsigned int)((t1 * 10u + t2) & 0xffffu);
}

void test_aliaswr(void)
{
    slot = 0;
    assertEqual(ind_ptr(&slot, 3u, 4u), 7u);
    assertEqual(slot, 7u);

    assertEqual(ind_stale(3u), 58u);
    assertEqual(ind_stale(0u), 25u);

    assertEqual(call_esc(2u, 3u), 56u);
    assertEqual(call_esc(0u, 0u), 1u);

    assertEqual(synth_glob(2u), 1121u);

    assertEqual(licm_esc(2u), 54u);

    assertEqual(keep_cse(1u), 42u);
    assertEqual(keep_compound(1u), 58u);

    o1 = o2 = 0;
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("a write through a pointer names no symbol");
    suite_add_test(test_aliaswr);
    return suite_run();
}
