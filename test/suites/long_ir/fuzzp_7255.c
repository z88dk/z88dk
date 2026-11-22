/* [fuzz-found] a byte value held only in DE lost its claim when a later byte store formed a slot address (its own slot was elided).
 * Its printed output must equal fuzzp_7255.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 255, g1 = 256;
unsigned char gb = 2;
unsigned short garr[4] = {100, 1, 1, 0};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 2, b = 256, c = 100;
  unsigned char x = 100;
  unsigned char i, j, k;
  unsigned short arr[4] = {255, 7, 256, 100};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  garr[0] -= (unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)a) & ((unsigned short)g0))) & 3)]) & ((unsigned short)garr[1]));
  q = &c;
  x = (unsigned short)(((unsigned short)((7) >> (3))) ^ ((unsigned short)(((unsigned short)arr[0]) | ((unsigned short)x))));
  p = &arr[0];
  x &= (unsigned short)*r;
  *ps[0] = (unsigned short)a;
  (g0)++;
  gb = (unsigned short)(((unsigned short)(((unsigned short)x) & ((unsigned short)*r))) | ((unsigned short)((rd(r)) - ((unsigned short)g1))));
  p = &arr[3];
  (arr[0])--;
  if (((unsigned short)(((unsigned short)gb) * ((unsigned short)(((unsigned short)(((unsigned short)x) & ((unsigned short)*r))) | ((unsigned short)((rd(r)) - ((unsigned short)g1))))))) > ((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)(((unsigned short)x) & ((unsigned short)*r))) | ((unsigned short)((rd(r)) - ((unsigned short)g1))))) & 3)]) - ((unsigned short)x)))) { (g1)--; if (((unsigned short)(((unsigned short)garr[3]) + ((unsigned short)*p))) >= ((unsigned short)g0)) { a |= (unsigned short)*p; sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)((7) >> (3))) ^ ((unsigned short)(((unsigned short)arr[0]) | ((unsigned short)x))))) + ((unsigned short)x))) * ((unsigned short)(((unsigned short)((7) >> (3))) ^ ((unsigned short)(((unsigned short)arr[0]) | ((unsigned short)x)))))))); } else { wr(r, (unsigned short)*ps[0]); } }
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)a) & ((unsigned short)g0))) & 3)]) & ((unsigned short)garr[1]))));
  *ps[1] = 0;
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
