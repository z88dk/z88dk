/* [fuzz-found] copt rule #DE6 took the register name de for a constant and produced ld de,de.
 * Its printed output must equal fuzzp_6486.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 1, g1 = 1;
unsigned char gb = 255;
unsigned short garr[4] = {7, 65535, 65535, 0};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 2, b = 1, c = 2;
  unsigned char x = 100;
  unsigned char i, j, k;
  unsigned short arr[4] = {256, 255, 0, 100};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  a = (unsigned short)(((unsigned short)(((unsigned short)*r) - ((unsigned short)garr[(((unsigned short)(((unsigned short)a) ^ ((unsigned short)arr[(((unsigned short)(((unsigned short)x) ^ ((unsigned short)*ps[0]))) & 3)]))) & 3)]))) | ((unsigned short)(((unsigned short)garr[2]) | ((unsigned short)*p))));
  *q = (unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) ^ ((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))));
  for (i = 0; i < 2; i++) { gb = (unsigned short)(((unsigned short)*q) << (1)); g1 = (unsigned short)(((unsigned short)(((unsigned short)arr[2]) >> (1))) * ((unsigned short)(((unsigned short)garr[(((unsigned short)garr[(((unsigned short)(((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))) - ((unsigned short)(((unsigned short)*q) << (1))))) & 3)]) & 3)]) << (3)))); arr[1] = (unsigned short)(((unsigned short)(((unsigned short)arr[0]) & ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))) & ((unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) ^ ((unsigned short)x)))); }
  if (((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))) - ((unsigned short)(((unsigned short)*q) << (1))))) + ((unsigned short)c))) >= ((unsigned short)(((unsigned short)*q) << (2)))) { *r = (unsigned short)(((unsigned short)((65535) ^ ((unsigned short)*q))) + ((unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) - ((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1])))))))); *p = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))) - ((unsigned short)(((unsigned short)*q) << (1))))) ^ ((unsigned short)x))) & ((unsigned short)(((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))) - ((unsigned short)(((unsigned short)*q) << (1)))))); }
  c = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) * ((unsigned short)*q))) - ((unsigned short)((7) & ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))));
  c = (unsigned short)(((unsigned short)(((unsigned short)g1) - ((unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) * ((unsigned short)*q))))) << (3));
  bump(r);
  wr(r, (unsigned short)(((unsigned short)c) + ((unsigned short)*q)));
  *q = (unsigned short)(((unsigned short)*ps[0]) << (3));
  if (((unsigned short)(((unsigned short)*p) ^ ((unsigned short)arr[2]))) == ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) * ((unsigned short)*q))) | ((unsigned short)g1)))) { if (((unsigned short)(((unsigned short)arr[0]) >> (1))) != ((unsigned short)(((unsigned short)*ps[1]) * (5)))) { arr[(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*r) | ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))))) - ((unsigned short)(((unsigned short)*q) << (1))))) ^ ((unsigned short)x))) * ((unsigned short)c))) & 3)] = (unsigned short)(((unsigned short)*q) * (rd(q))); } else { arr[1] = rd(q); garr[0] = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*q) << (1))) + ((unsigned short)g0))) & ((unsigned short)(((unsigned short)b) >> (3)))); } *p = (unsigned short)(((unsigned short)((7) | ((unsigned short)*ps[1]))) + ((unsigned short)(((unsigned short)*p) * ((unsigned short)(((unsigned short)*q) << (1)))))); } else { *q = (unsigned short)(((unsigned short)*r) + ((unsigned short)((256) + ((unsigned short)*q)))); }
  q = &garr[1];
  *ps[1] = (unsigned short)(((unsigned short)(((unsigned short)*q) << (1))) - ((unsigned short)(((unsigned short)*ps[1]) ^ ((unsigned short)arr[(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) & 3)]))));
  *r = (unsigned short)(((unsigned short)(((unsigned short)arr[2]) >> (2))) >> (3));
  wr(r, (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)b) - ((unsigned short)arr[1]))) * ((unsigned short)*q))) ^ ((unsigned short)(((unsigned short)*q) << (1)))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
