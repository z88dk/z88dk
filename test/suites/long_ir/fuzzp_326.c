/* [fuzz-found] a slot-less word was read through a bogus sp offset (slot -1 plus the sp adjust).
 * Its printed output must equal fuzzp_326.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 1, g1 = 40000;
unsigned char gb = 100;
unsigned short garr[4] = {0, 40000, 256, 1};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 1, b = 100, c = 255;
  unsigned char x = 255;
  unsigned char i, j, k;
  unsigned short arr[4] = {2, 1, 255, 1};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  sink = (unsigned short)(sink * 31 + ((unsigned short)*ps[0]));
  arr[(((unsigned short)(((unsigned short)garr[3]) >> (3))) & 3)] ^= (unsigned short)(((unsigned short)arr[1]) & ((unsigned short)c));
  q = &arr[2];
  a = (unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1));
  wr(q, (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1))) * ((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1)))));
  a &= (unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1));
  q = &g1;
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1))) * ((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1))))));
  gb = (unsigned short)(((unsigned short)(((unsigned short)x) | ((unsigned short)x))) | ((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1))));
  *q = (unsigned short)(((unsigned short)(((unsigned short)*q) + ((unsigned short)*ps[1]))) * ((unsigned short)(((unsigned short)*r) >> (1))));
  *p = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1))) * ((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)x))) ^ ((unsigned short)g1))))) | ((unsigned short)(((unsigned short)g1) | ((unsigned short)a))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
