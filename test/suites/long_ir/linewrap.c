/* Statements whose first token ends a line — the lexer must not lose its
 * place at the line boundary.
 *
 * dolabel() runs at the head of every statement to test for `ident:`. It
 * saved lptr, read the identifier, then probed for the colon with cmatch(),
 * which calls blanks() -- and blanks() REFILLS line[] with the next line once
 * the identifier ends the current one. The `lptr = savelptr` backtrack then
 * restored an index from the OLD line into the NEW line's buffer, dropping
 * the parser mid-token further down it: the call below lexed phantom
 * identifiers out of a later `return` ("n", "rn", "turn", depending on the
 * indentation) or died with "Invalid expression".
 *
 * This is the shape the binary-trees benchmark ships with:
 *
 *     printf
 *     (
 *        "Out of Memory, item %ld\n",
 *        item
 *     );
 *
 * sccz80 probes the colon with a bare gch(), which never refills, so its
 * backtrack always stays on one line. 80cc now bails out of the probe when
 * nothing is left on the current line, restoring that invariant.
 *
 * Only the FIRST token of a statement matters (that is what dolabel reads),
 * so `r = f\n(1);` and `return f\n(1);` were always fine -- they are here to
 * keep working. Labels and goto share the path and must still resolve. */
#include "test.h"

static int lw_sink;
static int lw_add(int a, int b) { return a + b; }
static int lw_one(int a)        { return a; }

/* call statement: callee ends the line, `(` opens the next */
static int lw_call_stmt(void)
{
    lw_sink = 0;
    lw_sink = lw_add(1, 2);
    lw_one
    (
        7
    );
    return lw_sink;
}

/* same, but with the argument list split further and no indentation */
static int lw_call_flush(void)
{
    lw_sink = 5;
    lw_add
(
1,
2
);
    return lw_sink;
}

/* assignment operator on the next line */
static int lw_assign(void)
{
    int v;
    v
    = 11;
    return v;
}

/* compound operator on the next line */
static int lw_compound(void)
{
    int v = 4;
    v
    += 6;
    return v;
}

/* the first token is an array/deref lvalue that ends the line */
static int lw_index(void)
{
    static int a[3];
    a[0] = 1;
    a
    [0] = 9;
    return a[0];
}

/* labels still resolve, including one alone on its line with a
 * line-wrapped statement after it */
static int lw_label(void)
{
    int i = 0, n = 0;
lw_loop:
    i++;
    if (i < 3) goto lw_loop;
    goto lw_done;
    n = 99;                      /* unreachable */
lw_done:
    n
    = i;
    return n;
}

static void test_linewrap(void)
{
    Assert(lw_call_stmt() == 3,  "call statement with ( on the next line");
    Assert(lw_call_flush() == 5, "call statement, args split, no indent");
    Assert(lw_assign() == 11,    "assignment with = on the next line");
    Assert(lw_compound() == 10,  "compound assign with += on the next line");
    Assert(lw_index() == 9,      "indexed store with [ on the next line");
    Assert(lw_label() == 3,      "labels and goto still resolve");
}

int main(int argc, char *argv[])
{
    suite_setup("statements wrapped after their first token");
    suite_add_test(test_linewrap);
    return suite_run();
}
