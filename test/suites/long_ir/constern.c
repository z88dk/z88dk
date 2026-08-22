/* Constant-expression folding of `?:` (ast_fold_constants, AST_TERNARY).
 *
 * A constant expression is folded by ast_fold_constants ALONE — constexpr()
 * in primary.c calls that one pass and reads the resulting AST_LITERAL. It
 * had no AST_TERNARY case, so a conditional operator with a literal condition
 * never reduced to a literal and every constant context rejected it with
 * "Expecting constant expression". FatFs (ff.c) hit this on
 *   BYTE buf[FF_FS_EXFAT ? SZDIRE * 2 : SZDIRE];
 *
 * The fold picks the selected arm and drops the other one. That is correct
 * whatever the dead arm contains, because only one arm of `?:` is ever
 * evaluated. It is gated on the selected arm already being a literal, so
 * non-constant shapes stay untouched and keep going through ast_dead_code —
 * which performs the same collapse later in ast_opt_run.
 *
 * Self-verifying with explicit constants; no printf.
 */
#include "test.h"

#define ZERO 0
#define ONE  1
#define SZ   8

/* The ff.c shape: array bound behind a constant `?:`. */
static unsigned char buf_false[ZERO ? SZ * 2 : SZ];
static unsigned char buf_true[ONE ? SZ * 2 : SZ];

/* Nested, and with the condition itself an expression to fold first. */
static unsigned char buf_nest[(SZ > 4) ? (ZERO ? 1 : SZ + 2) : 1];

/* Other constant contexts: enum member, case label, static initialiser. */
enum { E_A = ONE ? 7 : 9, E_B = ZERO ? 7 : 9 };

static int g_init = ZERO ? 100 : 200;

static int pick(int x)
{
    switch (x) {
    case (ONE ? 3 : 4):  return 30;
    case (ZERO ? 5 : 6): return 60;
    default:             return 0;
    }
}

/* A ternary on a NON-constant condition must still work normally. */
static int runtime_pick(int x) { return x > 2 ? SZ * 2 : SZ; }

static void test_constern(void)
{
    assertEqual(sizeof(buf_false), 8u);
    assertEqual(sizeof(buf_true), 16u);
    assertEqual(sizeof(buf_nest), 10u);

    assertEqual(E_A, 7);
    assertEqual(E_B, 9);
    assertEqual(g_init, 200);

    assertEqual(pick(3), 30);
    assertEqual(pick(6), 60);
    assertEqual(pick(5), 0);

    assertEqual(runtime_pick(9), 16);
    assertEqual(runtime_pick(1), 8);

    /* The arrays must be real, distinct storage. */
    buf_false[0] = 1;
    buf_true[0] = 2;
    assertEqual(buf_false[0], 1);
    assertEqual(buf_true[0], 2);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("Constant-condition ?: folds to a constant expression");
    suite_add_test(test_constern);
    return suite_run();
}
