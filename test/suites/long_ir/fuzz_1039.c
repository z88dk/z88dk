/* [fuzz-found] s = s*31 + E twice: the second statement became s = s.
 * A reduced program from the differential fuzzer. The body must stay in main:
 * main is exempt from the fp-to-sp frame flip and has its own frame set-up, and
 * these bugs did not reproduce from an ordinary function. The checksum of every
 * variable the original printed is compared with gcc's.
 */
#include "test.h"

unsigned short g0 = 2, g1 = 7;
unsigned char gb = 1;
unsigned short garr[4] = {0, 7, 256, 1};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }

static unsigned short result;

static void check(void)
{
    assertEqual(result, 17259);
}

int main(int argc, char *argv[])
{
  (void)argc; (void)argv;

  unsigned short a = 2, b = 2, c = 0;
  unsigned char x = 2;
  unsigned char i, j, k;
  unsigned short arr[4] = {0, 1, 255, 0};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  bump(r);
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) >> (1))) ^ ((unsigned short)(((unsigned short)*q) | ((unsigned short)*p))))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) >> (1))) ^ ((unsigned short)(((unsigned short)*q) | ((unsigned short)*p))))));

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
  suite_setup("fuzz reproducer 1039");
  suite_add_test(check);
  return suite_run();
}
