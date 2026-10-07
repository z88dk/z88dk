/* [fuzz-found] kc160 mul de,hl was not recorded as writing HL, so a stale HL constant was reused.
 * Its printed output must equal fuzzp_327.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 0, g1 = 65535;
unsigned char gb = 64;
unsigned short garr[4] = {255, 2, 2, 7};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 40000, b = 7, c = 1;
  unsigned char x = 2;
  unsigned char i, j, k;
  unsigned short arr[4] = {2, 1, 7, 7};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  if (((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) ^ ((unsigned short)(((unsigned short)*r) & ((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (3))) & 3)]))))) | ((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))))) >= ((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) ^ ((unsigned short)(((unsigned short)*r) & ((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (3))) & 3)])))))) { c = (unsigned short)*p; bump(r); arr[3] -= (unsigned short)a; } else { sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) ^ ((unsigned short)(((unsigned short)*r) & ((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (3))) & 3)])))))); }
  *ps[1] &= (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) ^ ((unsigned short)(((unsigned short)*r) & ((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (3))) & 3)]))))) & ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) ^ ((unsigned short)(((unsigned short)*r) & ((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (3))) & 3)]))))) | ((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))))));
  garr[(((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) + ((unsigned short)garr[(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)x) & ((unsigned short)*ps[0]))) & 3)]) | ((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))))) & 3)]))) & 3)] = (unsigned short)(((unsigned short)((0) & ((unsigned short)*p))) * ((unsigned short)(((unsigned short)b) * ((unsigned short)*p))));
  x = (unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)gb) >> (3))) & 3)]) ^ ((unsigned short)*r));
  sink = (unsigned short)(sink * 31 + ((unsigned short)((rd(p)) ^ ((unsigned short)(((unsigned short)b) - ((unsigned short)arr[(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))) ^ ((unsigned short)(((unsigned short)*r) & ((unsigned short)garr[(((unsigned short)(((unsigned short)g1) << (3))) & 3)]))))) | ((unsigned short)(((unsigned short)arr[1]) | ((unsigned short)*p))))) << (3))) & 3)]))))));
  (*r)++;
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
