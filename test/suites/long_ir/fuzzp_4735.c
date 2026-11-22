/* [fuzz-found] the dead-store pass walked a shared-subtree expression once per path: compile time was exponential in the nesting.
 * Its printed output must equal fuzzp_4735.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 65535, g1 = 65535;
unsigned char gb = 100;
unsigned short garr[4] = {1, 1, 1, 0};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 1, b = 65535, c = 100;
  unsigned char x = 7;
  unsigned char i, j, k;
  unsigned short arr[4] = {2, 255, 0, 100};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((3) ^ ((unsigned short)*q))) ^ ((unsigned short)(((unsigned short)c) - ((unsigned short)*q))))));
  p = &g0;
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))));
  for (i = 0; i < 3; i++) { gb = (unsigned short)(((unsigned short)(((unsigned short)c) * ((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))) & 3)]) - ((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))))) & 3)]))) - ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) << (1)))); for (j = 0; j < 1; j++) { *p = (unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))))) | ((unsigned short)(((unsigned short)a) + ((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0)))))); } }
  r = &garr[1];
  *ps[1] = (unsigned short)(((unsigned short)x) >> (1));
  *ps[1] = (unsigned short)(((unsigned short)(((unsigned short)*p) + ((unsigned short)*p))) * ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)c) * ((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))) & 3)]) - ((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))))) & 3)]))) - ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) << (1))))) >> (2))));
  *q = (unsigned short)x;
  if (((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) << (1))) > ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))) | ((unsigned short)*p)))) { x = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*p) ^ ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))))) | ((unsigned short)(((unsigned short)a) + ((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))))))) ^ ((unsigned short)(((unsigned short)c) << (3)))); (garr[(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))) << (3))) & 3)])++; } else { bump(q); (*r)--; }
  a = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))) ^ ((unsigned short)g0))) - ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)gb) + ((unsigned short)b))) - (0))) - ((unsigned short)arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (1))) & 3)]) | ((unsigned short)*ps[0]))) & 3)]) ^ ((unsigned short)*p))) & 3)]))) >> (3))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)b) ^ ((unsigned short)*q))) ^ ((unsigned short)(((unsigned short)garr[0]) << (2))))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
