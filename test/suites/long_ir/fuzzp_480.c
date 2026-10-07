/* [fuzz-found] de-widen produced ld l,l, which the assembler rejects.
 * Its printed output must equal fuzzp_480.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 256, g1 = 100;
unsigned char gb = 255;
unsigned short garr[4] = {40000, 7, 100, 1};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 7, b = 7, c = 1;
  unsigned char x = 2;
  unsigned char i, j, k;
  unsigned short arr[4] = {100, 65535, 2, 255};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  a ^= (unsigned short)((2) + ((unsigned short)*r));
  for (i = 0; i < 3; i++) { g1 = (unsigned short)(((unsigned short)(((unsigned short)garr[1]) << (2))) << (3)); }
  wr(r, (unsigned short)(((unsigned short)a) << (2)));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((0) << (1))) | ((unsigned short)(((unsigned short)g1) & (255))))));
  bump(q);
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)garr[1]) << (2))) ^ ((unsigned short)*p))) - ((unsigned short)(((unsigned short)(((unsigned short)garr[1]) << (2))) + ((unsigned short)b))))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
