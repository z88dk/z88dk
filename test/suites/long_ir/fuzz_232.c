/* [fuzz-found] a word parked on the stack whose one use is a byte operation.
 * A reduced program from the differential fuzzer. The body must stay in main:
 * main is exempt from the fp-to-sp frame flip and has its own frame set-up, and
 * these bugs did not reproduce from an ordinary function. The checksum of every
 * variable the original printed is compared with gcc's.
 */
#include "test.h"

unsigned short g0 = 100, g1 = 1;
unsigned char gb = 7;
unsigned short garr[4] = {1, 1, 100, 100};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }

static unsigned short result;

static void check(void)
{
    assertEqual(result, 30715);
}

int main(int argc, char *argv[])
{
  (void)argc; (void)argv;

  unsigned short a = 2, b = 256, c = 2;
  unsigned char x = 255;
  unsigned char i;
  unsigned short arr[4] = {1, 255, 100, 255};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  x = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)g0) >> (3))) + ((unsigned short)*ps[0]))) << (1));

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
  suite_setup("fuzz reproducer 232");
  suite_add_test(check);
  return suite_run();
}
