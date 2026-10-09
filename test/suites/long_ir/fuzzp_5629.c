/* [fuzz-found] a byte held in DE lost its claim when an index-register word was moved to HL, and the byte ALU operand path then read a slot it does not have.
 * Its printed output must equal fuzzp_5629.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 40000, g1 = 2;
unsigned char gb = 7;
unsigned short garr[4] = {100, 0, 2, 7};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 1, b = 100, c = 100;
  unsigned char x = 255;
  unsigned char i, j, k;
  unsigned short arr[4] = {0, 65535, 7, 7};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  *p = (unsigned short)(((unsigned short)(((unsigned short)c) & ((unsigned short)g0))) + ((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)a) | ((unsigned short)arr[(((unsigned short)(((unsigned short)*p) | (256))) & 3)]))) & 3)]) ^ ((unsigned short)(((unsigned short)*p) | (256))))));
  b = (unsigned short)(((unsigned short)(((unsigned short)*r) & ((unsigned short)*r))) + ((unsigned short)(((unsigned short)(((unsigned short)*r) & ((unsigned short)*r))) * ((unsigned short)garr[3]))));
  gb = (unsigned short)(((unsigned short)((rd(r)) - ((unsigned short)*p))) & ((unsigned short)*ps[0]));
  *q = (unsigned short)(((unsigned short)(((unsigned short)*r) + ((unsigned short)*p))) >> (3));
  *ps[1] = (unsigned short)c;
  *ps[1] = (unsigned short)arr[1];
  garr[(((unsigned short)g1) & 3)] = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*r) & ((unsigned short)*r))) << (3))) << (1));
  wr(r, (unsigned short)(((unsigned short)(((unsigned short)*r) & ((unsigned short)*r))) << (3)));
  x = (unsigned short)(((unsigned short)((rd(p)) >> (1))) & ((unsigned short)((7) - ((unsigned short)g1))));
  for (i = 0; i < 3; i++) { p = &arr[0]; gb = (unsigned short)(((unsigned short)(((unsigned short)*r) & ((unsigned short)*r))) << (3)); c = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)((rd(r)) - ((unsigned short)*p))) & ((unsigned short)*ps[0]))) ^ ((unsigned short)arr[(((unsigned short)(((unsigned short)(((unsigned short)*r) + ((unsigned short)*p))) | (7))) & 3)]))) << (1)); }
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
