/* [fuzz-found] the inc-mem liveness walk read Rabbit's `xor a,(sp+n)` as the zeroing idiom `xor a`, so the value left in A looked dead.
 * Its printed output must equal fuzzp_929.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 7, g1 = 65535;
unsigned char gb = 1;
unsigned short garr[4] = {100, 1, 40000, 255};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 100, b = 100, c = 0;
  unsigned char x = 255;
  unsigned char i, j, k;
  unsigned short arr[4] = {7, 100, 7, 256};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  p = &arr[3];
  a = (unsigned short)a;
  arr[(((unsigned short)(((unsigned short)arr[(((unsigned short)((255) >> (2))) & 3)]) | ((unsigned short)*q))) & 3)] = (unsigned short)garr[3];
  (x)--;
  x = (unsigned short)(((unsigned short)(((unsigned short)x) ^ ((unsigned short)c))) | ((unsigned short)(((unsigned short)x) << (3))));
  garr[3] = (unsigned short)(((unsigned short)(((unsigned short)*r) << (1))) << (2));
  *p = (unsigned short)(((unsigned short)(((unsigned short)arr[3]) + ((unsigned short)arr[(((unsigned short)*q) & 3)]))) >> (1));
  *r = (unsigned short)(((unsigned short)(((unsigned short)*ps[1]) * (rd(r)))) * ((unsigned short)(((unsigned short)((255) >> (2))) | ((unsigned short)(((unsigned short)(((unsigned short)arr[3]) + ((unsigned short)arr[(((unsigned short)*q) & 3)]))) >> (1))))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) * (rd(r)))) * ((unsigned short)(((unsigned short)((255) >> (2))) | ((unsigned short)(((unsigned short)(((unsigned short)arr[3]) + ((unsigned short)arr[(((unsigned short)*q) & 3)]))) >> (1))))))) >> (3))));
  (c)++;
  *ps[0] = (unsigned short)(((unsigned short)(((unsigned short)c) ^ ((unsigned short)arr[(((unsigned short)((rd(q)) + ((unsigned short)*p))) & 3)]))) * ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) * (rd(r)))) * ((unsigned short)(((unsigned short)((255) >> (2))) | ((unsigned short)(((unsigned short)(((unsigned short)arr[3]) + ((unsigned short)arr[(((unsigned short)*q) & 3)]))) >> (1))))))) | ((unsigned short)arr[(((unsigned short)(((unsigned short)g1) + ((unsigned short)(((unsigned short)(((unsigned short)*ps[1]) * (rd(r)))) * ((unsigned short)(((unsigned short)((255) >> (2))) | ((unsigned short)(((unsigned short)(((unsigned short)arr[3]) + ((unsigned short)arr[(((unsigned short)*q) & 3)]))) >> (1))))))))) & 3)]))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
