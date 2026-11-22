/* [fuzz-found] ast_cse_synthesize hoisted a pointer read over a direct write to the escaped local.
 * A reduced program from the differential fuzzer. The body must stay in main:
 * main is exempt from the fp-to-sp frame flip and has its own frame set-up, and
 * these bugs did not reproduce from an ordinary function. The checksum of every
 * variable the original printed is compared with gcc's.
 */
#include "test.h"

unsigned short g0 = 65535, g1 = 7;
unsigned char gb = 255;
unsigned short garr[4] = {2, 7, 40000, 0};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }

static unsigned short result;

static void check(void)
{
    assertEqual(result, 1883);
}

int main(int argc, char *argv[])
{
  (void)argc; (void)argv;

  unsigned short a = 40000, b = 40000, c = 0;
  unsigned char x = 64;
  unsigned char i;
  unsigned short arr[4] = {0, 40000, 1, 40000};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  for (i = 0; i < 2; i++) { sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((255) | ((unsigned short)(((unsigned short)*q) | ((unsigned short)*ps[0]))))) + ((unsigned short)(((unsigned short)(((unsigned short)*q) | ((unsigned short)*ps[0]))) >> (1)))))); c ^= (unsigned short)(((unsigned short)a) << (3)); }

  unsigned short h = 0;
  unsigned char hk;
  h = (unsigned short)(h * 31 + (unsigned short)a);
  h = (unsigned short)(h * 31 + (unsigned short)b);
  h = (unsigned short)(h * 31 + (unsigned short)c);
  h = (unsigned short)(h * 31 + (unsigned short)x);
  h = (unsigned short)(h * 31 + (unsigned short)sink);
  h = (unsigned short)(h * 31 + (unsigned short)g0);
  h = (unsigned short)(h * 31 + (unsigned short)g1);
  h = (unsigned short)(h * 31 + (unsigned short)gb);
  for (hk = 0; hk < 4; hk++) h = (unsigned short)(h * 31 + arr[hk] + garr[hk]);
  result = h;
  suite_setup("fuzz reproducer 161");
  suite_add_test(check);
  return suite_run();
}
