/* Void-typed hoist candidates (ast_opt: is_cse_interesting).
 *
 * CSE and LICM both materialise their chosen subtree as a synthesized local.
 * An OP_CAST is interesting by shape, so `(void)expr` was picked and given a
 * void temp, which ir_build refuses ("AST_DECL: kind 1 not yet supported").
 * FreeRTOS tasks.c hits it via `( void ) var;` next to a hoistable expression.
 * The operand is still hoisted — only the cast is rejected.
 */
#include "test.h"

static int g_k;
static int g_calls;

static int leaf(int x) { g_calls++; return x + 1; }

/* LICM: an invariant expression to hoist, next to a `(void)` cast of an
 * equally invariant expression. The cast must not become the temp. */
static int licm_void(int n, int p)
{
    int i, s = 0;
    for (i = 0; i < n; i++) {
        s += p + g_k;
        (void) (p + g_k);
    }
    return s;
}

/* CSE: the same void-cast expression repeated, interleaved with real uses
 * of the identical subtree. */
static int cse_void(int p)
{
    int r = 0;
    (void) (p * 3 + g_k);
    r += p * 3 + g_k;
    (void) (p * 3 + g_k);
    r += p * 3 + g_k;
    return r;
}

/* A void cast of a call, and of a literal — neither is storable either. */
static int cast_forms(int p)
{
    (void) 0;
    (void) leaf(p);
    (void) (p + g_k);
    return p + g_k;
}

static void test_voidhoist(void)
{
    g_k = 4;
    g_calls = 0;

    assertEqual(licm_void(0, 10), 0);
    assertEqual(licm_void(1, 10), 14);
    assertEqual(licm_void(3, 10), 42);      /* 3 * (10 + 4) */

    assertEqual(cse_void(5), 38);           /* 2 * (5*3 + 4) */
    assertEqual(cse_void(0), 8);

    assertEqual(cast_forms(6), 10);
    assertEqual(g_calls, 1);                /* the cast-away call still ran */

    /* The hoisted value must track the global, not a stale temp. */
    g_k = 100;
    assertEqual(licm_void(2, 1), 202);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Void-typed CSE/LICM candidates are not hoisted");
    suite_add_test(test_voidhoist);
    return suite_run();
}
