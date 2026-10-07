/* [cse-alias] CSE keys on the earliest name of a value: a forwarded copy of
 * a global, a MOV, and a repeated &sym all meet the first computation.
 *
 * chain     board[tab[x*3 + k]] repeated, x a global char: every repeat shares
 *           the first x*3 and the address of tab.
 * wr_global x is stored between two reads of x*3; the second must see the new x.
 * wr_copy   `y = p` makes y an alias of p; redefining p must end the alias.
 * call_wr   a call changes the global between two x*3.
 * two_syms  same offset in two different arrays must not be shared.
 *
 * Loads through a pointer are shared too, when the address is recomputed from
 * a different vreg that is the same value (`board[threes[x*3+k]]`):
 * domove    the tic.c move search, stores in the branches, run against a plain
 *           reference over generated boards; results and boards must agree.
 */
#include "test.h"

static signed char x;
static unsigned char board[9] = { 10, 11, 12, 13, 14, 15, 16, 17, 18 };
static unsigned char other[9] = { 20, 21, 22, 23, 24, 25, 26, 27, 28 };
static const unsigned char tab[12] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 0, 4, 8 };

static void bump_x(void) { x++; }

static int chain(unsigned char want)
{
    int n = 0;
    if (board[tab[x * 3]] == want && board[tab[x * 3 + 1]] == want
        && board[tab[x * 3 + 2]] != want && board[tab[x * 3 + 2]] != 99)
        n += 1;
    if (board[tab[x * 3 + 1]] == want && board[tab[x * 3 + 2]] == want
        && board[tab[x * 3]] != want && board[tab[x * 3]] != 99)
        n += 2;
    return n;
}

static int wr_global(void)
{
    int a, b;
    a = x * 3;
    x = (signed char)(x + 1);
    b = x * 3;
    return a * 100 + b;
}

static int wr_copy(int p)
{
    int y = p;
    int t1 = y * 3 + 1;
    p = p + 2;
    int t2 = p * 3 + 1;
    return t1 * 100 + t2;
}

static int call_wr(void)
{
    int a = x * 3;
    bump_x();
    int b = x * 3;
    return a * 100 + b;
}

static int two_syms(int i)
{
    return board[i + 1] * 100 + other[i + 1] + board[i + 1];
}

/* tic.c's move search: the same x*3+k index chain feeds many board reads. */
static signed char gx;
static unsigned char bd[9], rf[9];
static const unsigned char th[24] = { 0, 1, 2, 3, 4, 5, 6, 7, 8,
                                      0, 3, 6, 1, 4, 7, 2, 5, 8,
                                      0, 4, 8, 2, 4, 6 };

static int dom_chain(unsigned char player, unsigned char opp)
{
    for (gx = 0; gx != 8; gx++) {
        if ((bd[th[gx * 3]] == player && bd[th[gx * 3 + 1]] == player)
            && (bd[th[gx * 3 + 2]] != player && bd[th[gx * 3 + 2]] != opp)) {
            bd[th[gx * 3 + 2]] = player;
            return 1;
        } else if ((bd[th[gx * 3 + 1]] == player && bd[th[gx * 3 + 2]] == player)
                   && (bd[th[gx * 3]] != player && bd[th[gx * 3]] != opp)) {
            bd[th[gx * 3]] = player;
            return 2;
        }
    }
    return 0;
}

static int dom_ref(unsigned char player, unsigned char opp)
{
    int x;
    for (x = 0; x != 8; x++) {
        int a = th[x * 3], b = th[x * 3 + 1], c = th[x * 3 + 2];
        unsigned char va = rf[a], vb = rf[b], vc = rf[c];
        if (va == player && vb == player && vc != player && vc != opp) {
            rf[c] = player;
            return 1;
        }
        if (vb == player && vc == player && va != player && va != opp) {
            rf[a] = player;
            return 2;
        }
    }
    return 0;
}

static void test_domove(void)
{
    unsigned int seed = 12345u;
    int bad = 0, seen1 = 0, seen2 = 0;

    for (int n = 0; n < 400; n++) {
        for (int i = 0; i < 9; i++) {
            seed = seed * 25173u + 13849u;
            bd[i] = rf[i] = (unsigned char)((seed >> 9) % 3u);
        }
        int r1 = dom_chain(1, 2);
        int r2 = dom_ref(1, 2);
        if (r1 != r2) bad++;
        for (int i = 0; i < 9; i++)
            if (bd[i] != rf[i]) bad++;
        if (r1 == 1) seen1++;
        if (r1 == 2) seen2++;
    }
    assertEqual(bad, 0);
    assertEqual(seen1 > 5 && seen2 > 5, 1);
}

void test_csealias(void)
{
    x = 0;
    board[0] = board[1] = 5; board[2] = 6;
    assertEqual(chain(5), 1);
    board[0] = 6; board[1] = board[2] = 5;
    assertEqual(chain(5), 2);
    board[0] = 10; board[1] = 11; board[2] = 12;

    x = 1;
    assertEqual(wr_global(), 3 * 100 + 6);
    assertEqual(x, 2);
    assertEqual(wr_copy(4), 13 * 100 + 19);
    x = 2;
    assertEqual(call_wr(), 6 * 100 + 9);
    assertEqual(two_syms(2), 13 * 100 + 23 + 13);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("cse across copies and repeated symbol addresses");
    suite_add_test(test_csealias);
    suite_add_test(test_domove);
    return suite_run();
}
