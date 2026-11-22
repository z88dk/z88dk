/* [fuzz-found] a rematerialised constant used as a byte ALU operand (slot sp-1).
 * Reduced program from the differential fuzzer; its printed output must equal
 * fuzzp_325.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 65535, g1 = 2;
unsigned char gb = 1;
unsigned short garr[4] = {1, 2, 255, 7};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 7, b = 7, c = 1;
  unsigned char x = 0;
  unsigned char i;
  unsigned short arr[4] = {1, 1, 2, 65535};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  q = &a;
  for (i = 0; i < 3; i++) { *p = (unsigned short)(((unsigned short)(((unsigned short)*p) * ((unsigned short)*r))) * ((unsigned short)(((unsigned short)*q) - ((unsigned short)*p)))); q = &arr[2]; }
  (*q)--;
  x = (unsigned short)(((unsigned short)(((unsigned short)b) & ((unsigned short)(((unsigned short)*q) - ((unsigned short)*p))))) << (1));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
