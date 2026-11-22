/* [fuzz-found] DE kept naming the old value of a spilled destination (fp).
 * Reduced program from the differential fuzzer; its printed output must equal
 * fuzzp_1478b.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 2, g1 = 2;
unsigned char gb = 0;
unsigned short garr[4] = {7, 40000, 65535, 256};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 65535, b = 255, c = 0;
  unsigned char x = 255;
  unsigned char i, j, k;
  unsigned short arr[4] = {65535, 40000, 100, 2};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  sink = (unsigned short)((unsigned short)(((unsigned short)(0 + ((unsigned short)*r))) - 0));
  sink = (unsigned short)(sink * 31 + 0);
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}

