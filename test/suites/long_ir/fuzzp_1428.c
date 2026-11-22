/* [fuzz-found] DE kept naming the old value of a subtract destination (fp).
 * Reduced program from the differential fuzzer; its printed output must equal
 * fuzzp_1428.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 65535, g1 = 65535;
unsigned char gb = 2;
unsigned short garr[4] = {2, 100, 256, 0};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 65535, b = 256, c = 256;
  unsigned char x = 64;
  unsigned char i, j, k;
  unsigned short arr[4] = {2, 2, 256, 65535};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  if (((unsigned short)((65535) ^ ((unsigned short)((3) >> (1))))) > ((unsigned short)arr[(((unsigned short)(((unsigned short)((3) >> (1))) & ((unsigned short)((3) >> (1))))) & 3)])) { *ps[1] = (unsigned short)arr[3]; garr[2] = (unsigned short)(((unsigned short)garr[(((unsigned short)c) & 3)]) << (3)); b = (unsigned short)(((unsigned short)(((unsigned short)*r) >> (3))) * ((unsigned short)((3) >> (1)))); } else { b += (unsigned short)(((unsigned short)((3) >> (1))) >> (2)); }
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((3) >> (1))) << (1))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
