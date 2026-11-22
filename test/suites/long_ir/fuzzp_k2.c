/* [fuzz-found] 8085: a narrowed byte loop counter kept the K-flag latch (jp nk), which only a 16-bit DEC sets, so the loop never ended.
 * Its printed output must equal fuzzp_k2.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 0, g1 = 1;
unsigned char gb = 1;
unsigned short garr[4] = {255, 2, 100, 100};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 7, b = 0, c = 2;
  unsigned char x = 0;
  unsigned char i, j, k;
  unsigned short arr[4] = {256, 65535, 255, 65535};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  p = &a;
  x ^= (unsigned short)(((unsigned short)arr[(((unsigned short)g1) & 3)]) ^ ((unsigned short)arr[1]));
  x &= (unsigned short)(((unsigned short)*q) * ((unsigned short)g0));
  (*q)--;
  for (i = 0; i < 3; i++) { if (((unsigned short)(((unsigned short)*r) >> (3))) <= ((unsigned short)(((unsigned short)*p) << (2)))) { bump(q); *r = (unsigned short)(((unsigned short)*p) >> (2)); } for (j = 0; j < 3; j++) { sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((1) & ((unsigned short)a))) + (rd(p))))); } b = (unsigned short)(((unsigned short)(((unsigned short)c) + ((unsigned short)a))) + ((unsigned short)(((unsigned short)(((unsigned short)c) + ((unsigned short)a))) + ((unsigned short)b)))); }
  arr[(((unsigned short)(((unsigned short)c) + ((unsigned short)a))) & 3)] = (unsigned short)(((unsigned short)x) >> (3));
  *r = (unsigned short)(((unsigned short)(((unsigned short)*p) - ((unsigned short)(((unsigned short)c) + ((unsigned short)a))))) >> (2));
  g1 ^= (unsigned short)((65535) + ((unsigned short)(((unsigned short)c) + ((unsigned short)a))));
  *p = (unsigned short)(((unsigned short)(((unsigned short)a) & ((unsigned short)garr[(((unsigned short)(((unsigned short)(((unsigned short)x) >> (3))) + ((unsigned short)a))) & 3)]))) + ((unsigned short)(((unsigned short)x) >> (3))));
  bump(q);
  b |= (unsigned short)(((unsigned short)g1) << (1));
  for (i = 0; i < 3; i++) { for (j = 0; j < 3; j++) { gb &= (unsigned short)garr[(((unsigned short)(((unsigned short)((65535) + ((unsigned short)(((unsigned short)c) + ((unsigned short)a))))) << (1))) & 3)]; bump(p); } }
  if (((unsigned short)(((unsigned short)c) + ((unsigned short)a))) != ((unsigned short)(((unsigned short)((65535) + ((unsigned short)(((unsigned short)c) + ((unsigned short)a))))) - (1)))) { *r |= (unsigned short)(((unsigned short)((65535) + ((unsigned short)(((unsigned short)c) + ((unsigned short)a))))) + ((unsigned short)(((unsigned short)c) + ((unsigned short)a)))); } else { r = &arr[1]; }
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
