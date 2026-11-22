/* [fuzz-found] a store through a pointer to a global was dropped as dead before a direct read of that global.
 * Its printed output must equal fuzzp_7421.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 2, g1 = 255;
unsigned char gb = 7;
unsigned short garr[4] = {2, 7, 65535, 100};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 256, b = 1, c = 2;
  unsigned char x = 1;
  unsigned char i, j, k;
  unsigned short arr[4] = {0, 1, 255, 40000};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((2) | ((unsigned short)a))) ^ ((unsigned short)(((unsigned short)x) ^ ((unsigned short)c))))));
  wr(p, (unsigned short)((65535) >> (3)));
  b -= (unsigned short)*r;
  sink = (unsigned short)(sink * 31 + ((unsigned short)garr[3]));
  a = (unsigned short)(((unsigned short)(((unsigned short)*r) | ((unsigned short)*q))) & ((unsigned short)c));
  wr(q, (unsigned short)((40000) ^ ((unsigned short)b)));
  q = &g0;
  *p = (unsigned short)((5) >> (2));
  *p = (unsigned short)*p;
  garr[3] -= (unsigned short)*p;
  r = &garr[1];
  *q |= (unsigned short)(((unsigned short)g1) - ((unsigned short)*ps[1]));
  (x)--;
  *q += (unsigned short)g0;
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)*p) | ((unsigned short)(((unsigned short)arr[0]) + ((unsigned short)arr[2]))))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
