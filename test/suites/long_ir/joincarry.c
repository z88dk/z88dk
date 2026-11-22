/* A BYTE SET IN THE ARMS OF AN if/else OR A NESTED TERNARY SURVIVES THE JOIN.
 *
 *     if (c) x = 1; else if (d) x = 2; else x = 3;   use(x);
 *     r = c ? a : (d ? b : e);
 *
 * The join block is created after its arms, so the lowerer sees every
 * predecessor before the join and can keep the value in A across it. Each
 * shape here would give a wrong value if the carry took the wrong register or
 * kept a stale one: arms that call (A is clobbered), return early, break out of
 * a loop, leave the old value in place, or feed a second join.
 */
#include "test.h"

static unsigned char ga = 11, gb = 22, gc = 33, out;
static int sink;

static unsigned char fnv(unsigned char v) { sink++; return (unsigned char)(v + 100); }

static unsigned char ie2(int c)
{ unsigned char x; if (c) x = 1; else x = 2; return x; }
static unsigned char ie3(int c, int d)
{ unsigned char x; if (c) x = 1; else if (d) x = 2; else x = 3; return x; }
static unsigned char ie4(int c, int d, int e)
{ unsigned char x; if (c) x = ga; else if (d) x = gb; else if (e) x = 7; else x = gc; return x; }
static unsigned char tern3(int c, int d)
{ return c ? ga : (d ? gb : gc); }
static unsigned char tern4(int c, int d, int e)
{ return c ? ga : (d ? 0 : (e ? gb : 255)); }
static void tern_store(int c, int d)
{ out = c ? 5 : (d ? 6 : ga); }

/* arms that clobber A */
static unsigned char call_arm(int c, int d)
{ unsigned char x; if (c) x = fnv(1); else if (d) x = 5; else x = fnv(2); return x; }
/* an arm that returns: the others must still join correctly */
static int early(int c, int d)
{ unsigned char x; if (c) return 99; else if (d) x = 4; else x = 6; return x + 1; }
/* the old value survives in the arm that does not assign */
static unsigned char keep(int c, int d)
{ unsigned char x = ga; if (c) x = 4; else if (d) x = 5; return x; }
/* two joins in a row, the second reading the first */
static unsigned char chain2(int c, int d)
{ unsigned char x, y; if (c) x = 3; else if (d) x = 8; else x = 1;
  if (x > 2) y = x + 10; else y = x + 20; return y; }
/* the joined value drives a branch */
static int branchy(int c, int d)
{ unsigned char x; if (c) x = 1; else if (d) x = 2; else x = 3;
  if (x == 2) return 200; if (x > 2) return 300; return 100; }
/* inside a loop; the else breaks out */
static int loopy(int n)
{ int i, s = 0; unsigned char x;
  for (i = 0; i < n; i++) { if (i & 1) x = 3; else if (i == 4) x = 9; else x = 1; s += x; }
  return s; }
static int loop_break(int n)
{ int i = 0, s = 0; unsigned char x;
  while (i < n) { if (i < 3) x = (unsigned char)(i + 1); else break; s += x; i++; }
  return s; }
/* wider and signed joins */
static int word_join(int c, int d)
{ int x; if (c) x = 1000; else if (d) x = -5; else x = 70; return x; }
static signed char sc_join(int c, int d)
{ signed char x; if (c) x = -3; else if (d) x = 4; else x = -128; return x; }
static unsigned char sw(int c)
{ unsigned char x; switch (c) { case 1: x = 10; break; case 2: x = ga; break; case 3: x = 30; break; default: x = 99; } return x; }


void test_joincarry(void)
{
    int c, d, e;
    ga = 11; gb = 22; gc = 33;
    for (c = 0; c < 2; c++) for (d = 0; d < 2; d++) {
        assertEqual(ie3(c, d), c ? 1 : d ? 2 : 3);
        assertEqual(tern3(c, d), c ? 11 : d ? 22 : 33);
        assertEqual(word_join(c, d), c ? 1000 : d ? -5 : 70);
        assertEqual(sc_join(c, d), c ? -3 : d ? 4 : -128);
        assertEqual(early(c, d), c ? 99 : d ? 5 : 7);
        assertEqual(keep(c, d), c ? 4 : d ? 5 : 11);
        assertEqual(chain2(c, d), c ? 13 : d ? 18 : 21);
        assertEqual(branchy(c, d), c ? 100 : d ? 200 : 300);
        for (e = 0; e < 2; e++) {
            assertEqual(ie4(c, d, e), c ? 11 : d ? 22 : e ? 7 : 33);
            assertEqual(tern4(c, d, e), c ? 11 : d ? 0 : e ? 22 : 255);
        }
    }
    assertEqual(ie2(0), 2);  assertEqual(ie2(1), 1);
    tern_store(1, 0); assertEqual(out, 5);
    tern_store(0, 1); assertEqual(out, 6);
    tern_store(0, 0); assertEqual(out, 11);
    sink = 0;
    assertEqual(call_arm(1, 0), 101);  assertEqual(sink, 1);
    assertEqual(call_arm(0, 1), 5);    assertEqual(sink, 1);
    assertEqual(call_arm(0, 0), 102);  assertEqual(sink, 2);
    assertEqual(loopy(6), 1 + 3 + 1 + 3 + 9 + 3);
    assertEqual(loop_break(10), 1 + 2 + 3);
    assertEqual(loop_break(2), 1 + 2);
    assertEqual(sw(1), 10);  assertEqual(sw(2), 11);  assertEqual(sw(3), 30);  assertEqual(sw(9), 99);
    ga = 200; gb = 201; gc = 202;
    assertEqual(ie4(0, 0, 0), 202);  assertEqual(ie4(0, 1, 0), 201);  assertEqual(tern3(1, 1), 200);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte set in if/else arms survives the join");
    suite_add_test(test_joincarry);
    return suite_run();
}
