/* [fuzz-found] a word homed in IY used as a byte ALU operand.
 * Reduced program from the differential fuzzer; its printed output must equal
 * fuzzp_1232.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 2, g1 = 100;
unsigned char gb = 0;
unsigned short garr[4] = {2, 0, 100, 65535};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 65535, b = 1, c = 0;
  unsigned char x = 2;
  unsigned char i, j, k;
  unsigned short arr[4] = {0, 100, 256, 1};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  for (i = 0; i < 2; i++) { a &= (unsigned short)((1000) & (1000)); arr[2] = (unsigned short)arr[1]; gb = (unsigned short)((rd(q)) ^ ((unsigned short)(((unsigned short)*r) - ((unsigned short)x)))); }
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
