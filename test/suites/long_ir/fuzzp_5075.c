/* [fuzz-found] a helper-call result was judged consumed from HL by the next op, but the fp slot-to-slot compare reads its operands from the frame, so the dropped store left a stale slot.
 * Its printed output must equal fuzzp_5075.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 2, g1 = 40000;
unsigned char gb = 100;
unsigned short garr[4] = {7, 1, 1, 40000};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 2, b = 65535, c = 40000;
  unsigned char x = 1;
  unsigned char i, j, k;
  unsigned short arr[4] = {2, 256, 7, 2};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  p = &arr[0];
  (x)--;
  *p -= (unsigned short)(((unsigned short)a) & ((unsigned short)g0));
  bump(p);
  x = 3;
  arr[1] = (unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0));
  for (i = 0; i < 3; i++) { for (j = 0; j < 1; j++) { (g0)--; *ps[0] = (unsigned short)*p; c = (unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0)); } }
  sink = (unsigned short)(sink * 31 + ((unsigned short)*p));
  g0 = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0))) | ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0))))) | ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0))) + ((unsigned short)garr[0]))));
  p = &arr[2];
  gb -= (unsigned short)((rd(q)) + ((unsigned short)a));
  if (((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)a) * ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0))))) & 3)]) * ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0))))) < ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0)))) { sink = (unsigned short)(sink * 31 + ((unsigned short)*p)); } else { sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((1000) << (1))) & ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0)))))); }
  c -= (unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)*p) - ((unsigned short)a))) & 3)]) & ((unsigned short)garr[(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) << (2))) - ((unsigned short)g0))) << (2))) & 3)]));
  *ps[1] ^= (unsigned short)*q;
  for (i = 0; i < 2; i++) { *r = 255; }
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
