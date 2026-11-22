/* [fuzz-found] copt #W1 turned a (sp+n) word load into the byte form ld a,(sp+n), which Rabbit does not have.
 * Its printed output must equal fuzzp_351.want (gcc's). The body must stay in main (see fuzz_*.c). */
#include <stdio.h>
unsigned short g0 = 255, g1 = 255;
unsigned char gb = 100;
unsigned short garr[4] = {255, 100, 40000, 256};
static void wr(unsigned short *p, unsigned short v) { *p = v; }
static unsigned short rd(unsigned short *p) { return *p; }
static void bump(unsigned short *p) { *p = (unsigned short)(*p + 3); }
int main(void) {
  unsigned short a = 7, b = 256, c = 40000;
  unsigned char x = 7;
  unsigned char i, j, k;
  unsigned short arr[4] = {100, 100, 100, 255};
  unsigned short *p = &a, *q = &b, *r = &arr[1];
  unsigned short *ps[2];
  unsigned short sink = 0;
  ps[0] = &c; ps[1] = &g0;
  r = &b;
  *p = (unsigned short)arr[(((unsigned short)((255) & ((unsigned short)*r))) & 3)];
  if (((unsigned short)b) < ((unsigned short)((255) & ((unsigned short)*r)))) { for (i = 0; i < 1; i++) { x = (unsigned short)((255) & ((unsigned short)*r)); } *q = (unsigned short)(((unsigned short)(((unsigned short)*r) + ((unsigned short)((255) & ((unsigned short)*r))))) << (1)); if (((unsigned short)((255) & ((unsigned short)*r))) == ((unsigned short)(((unsigned short)c) << (1)))) { x = (unsigned short)(((unsigned short)(((unsigned short)*q) - (5))) & ((unsigned short)((255) & ((unsigned short)*r)))); garr[(((unsigned short)(((unsigned short)g0) & ((unsigned short)arr[3]))) & 3)] |= (unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) ^ ((unsigned short)c)); } else { *ps[1] = (unsigned short)((255) & ((unsigned short)*r)); b = (unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) ^ ((unsigned short)((255) & ((unsigned short)*r)))); } } else { c = (unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p))))); wr(p, (unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))); }
  for (i = 0; i < 1; i++) { sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)g1) & ((unsigned short)a))) | ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) ^ ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p))))))))))); p = &b; }
  wr(q, (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)g1) & ((unsigned short)a))) | ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) ^ ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))))))) ^ (1)));
  b = (unsigned short)(((unsigned short)(((unsigned short)garr[(((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))) + ((unsigned short)((255) & ((unsigned short)*r))))) & 3)]) * ((unsigned short)*r))) << (2));
  for (i = 0; i < 2; i++) { *p |= (unsigned short)(((unsigned short)*ps[0]) & (5)); p = &arr[1]; (*r)--; }
  gb = (unsigned short)(((unsigned short)g0) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) - ((unsigned short)*q))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)*p) + ((unsigned short)(((unsigned short)g1) & ((unsigned short)a))))) + ((unsigned short)(((unsigned short)*p) + ((unsigned short)arr[(((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) - ((unsigned short)*q))) << (2))) & 3)]))))));
  if (((unsigned short)g0) > ((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))) >> (1)))) { c = rd(r); c = (unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)g1) & ((unsigned short)a))) | ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) ^ ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))))))) & ((unsigned short)((255) & ((unsigned short)*r))))) * ((unsigned short)(((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) - ((unsigned short)*q))) << (2))) - ((unsigned short)*q)))); }
  arr[(((unsigned short)((65535) | ((unsigned short)b))) & 3)] = (unsigned short)(((unsigned short)(((unsigned short)arr[(((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))) | ((unsigned short)(((unsigned short)g1) & ((unsigned short)a))))) & 3)]) | ((unsigned short)*ps[1]))) << (2));
  sink = (unsigned short)(sink * 31 + ((unsigned short)((255) & ((unsigned short)*r))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)(((unsigned short)*p) | ((unsigned short)*r))) * ((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))) + ((unsigned short)(((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) - ((unsigned short)*q))) << (2))))))));
  sink = (unsigned short)(sink * 31 + ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * ((unsigned short)(((unsigned short)((255) & ((unsigned short)*r))) * (rd(p)))))));
  printf("%u %u %u %u %u %u %u %u\n", a, b, c, g0, g1, x, gb, sink);
  printf("%u %u %u %u %u %u %u %u\n", arr[0], arr[1], arr[2], arr[3], garr[0], garr[1], garr[2], garr[3]);
  return 0;
}
