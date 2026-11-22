/* Sibling/nested block-scope locals must not alias one another.

   The front end pools local SYMBOLs in a fixed array and used to rewind the
   bump pointer when a block closed, reusing the slots for the next sibling
   block. But the IR is built from an AST that holds SYMBOL* into that array
   and is lowered only after the whole function is parsed, so the later decl's
   type retroactively rewrote the earlier one: three sibling-scope locals
   (double d / double d / long l) collapsed onto a single `long` symbol, and
   `double d = i` lost its int->double conversion (read back garbage).
   Reported as the "FA-slot" miscompile; the real cause is symbol-scope reuse,
   so it reproduces with floats *and* with plain int/long siblings. */
#include "test.h"

double g;
static double ret_int(int i){ return i; }

/* The original float repro: needs the full multi-double + long-block combo. */
static void test_faslot_double(void)
{
  int i = 7;
  g = i; assertEqual((int)g, 7);
  g = 9; assertEqual((int)g, 9);
  { double d = i; assertEqual((int)d, 7); }   /* used to read != 7 */
  { double d = 5; assertEqual((int)d, 5); }
  assertEqual((int)ret_int(11), 11);
  { long l = 1000; g = l; assertEqual((int)g, 1000); }
}

/* Float-free: sibling blocks of differing types must keep distinct symbols.
   `i` comes through a global so it isn't a foldable constant. */
volatile int gi = 6;
static void test_sibling_scopes(void)
{
  int i = gi;
  { int  a = i + 1; assertEqual(a, i + 1); }
  { long b = 5;     assertEqual((int)b, 5); }
  { int  a = i + 2; assertEqual(a, i + 2); }   /* fresh `a`, not aliased to b */
}

/* Sequential for-loops reusing the same loop-var name. */
static void test_for_loop_vars(void)
{
  int s = 0;
  for (int k = 0; k < 4; k++) s += k;          /* 0+1+2+3 = 6 */
  assertEqual(s, 6);
  for (int k = 0; k < 3; k++) s += 10;         /* +30 */
  assertEqual(s, 36);
}

int main(int argc, char *argv[])
{
  suite_setup("faslot scope aliasing");
  suite_add_test(test_faslot_double);
  suite_add_test(test_sibling_scopes);
  suite_add_test(test_for_loop_vars);
  return suite_run();
}
