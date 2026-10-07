/* [fuzz-found] a rematerialised constant read into A under a stale slot-address belief; x = E into a narrower variable.
 * A reduced program from the differential fuzzer. The body must stay in main:
 * main is exempt from the fp-to-sp frame flip and has its own frame set-up, and
 * these bugs did not reproduce from an ordinary function. The checksum of every
 * variable the original printed is compared with gcc's.
 */
#include "test.h"

unsigned short g0 = 65535, g1 = 255;
unsigned char gb = 0;
unsigned short garr[4] = {100, 65535, 40000, 7};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }

static unsigned short result;

static void check(void)
{
    assertEqual(result, 34908);
}

int main(int argc, char *argv[])
{
  (void)argc; (void)argv;

  unsigned short a = 256, b = 0, c = 100;
  unsigned char x = 7;
  unsigned char i;
  unsigned short arr[4] = {7, 1, 2, 100};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  x = (unsigned short)(((unsigned short)(((unsigned short)*q) & ((unsigned short)*r))) + ((unsigned short)((2) ^ ((unsigned short)a))));

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
  suite_setup("fuzz reproducer 214");
  suite_add_test(check);
  return suite_run();
}
