/* [fuzz-found] a byte value held only in DE lost its claim when a later byte store formed a slot address (its own slot was elided).
 * Its printed output must equal fuzzp_6302.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 2, g1 = 7;
unsigned char gb = 7;
unsigned short garr[4] = {0, 0, 65535, 40000};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 40000, b = 100, c = 2;
  unsigned char x = 64;
  unsigned char i, j, k;
  unsigned short arr[4] = {2, 1, 1, 1};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  arr[((1) & 3)] = (unsigned short)*p;
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((65535) | ((unsigned short)*ps[1]))) - ((unsigned short)x))));
  b = (unsigned short)*p;
  arr[(((unsigned short)(((unsigned short)x) - ((unsigned short)gb))) & 3)] = (unsigned short)(((unsigned short)(((unsigned short)c) ^ ((unsigned short)b))) & ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)x) & ((unsigned short)arr[2]))) & 3)]) ^ ((unsigned short)*p))) & 3)]));
  x = (unsigned short)(((unsigned short)arr[2]) | ((unsigned short)((rd(r)) - ((unsigned short)garr[((1) & 3)]))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)arr[3]));
  (arr[(((unsigned short)((2) - (0))) & 3)])++;
  arr[2] = (unsigned short)(((unsigned short)((rd(p)) & ((unsigned short)x))) + ((unsigned short)(((unsigned short)*r) + ((unsigned short)*r))));
  garr[3] |= (unsigned short)g1;
  arr[1] -= (unsigned short)(((unsigned short)a) | ((unsigned short)*r));
  *r = (unsigned short)(((unsigned short)(((unsigned short)c) >> (1))) ^ ((unsigned short)*ps[0]));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
