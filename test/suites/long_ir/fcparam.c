/* multi-arg __z88dk_fastcall: rightmost arg in HL, the rest on the stack.
   Regression guard for the autopush miscompile (autopush of the HL arg shifted
   sp but the stack-param reads/epilogue didn't account for it → wild return). */
#include "test.h"
typedef unsigned char u8;
static int   isub(int a, int b) __z88dk_fastcall { return a - b; }
static int   ifst(int a, int b) __z88dk_fastcall { return a; }
static int   isnd(int a, int b) __z88dk_fastcall { return b; }
static int   i3(int a, int b, int c) __z88dk_fastcall { return a*100 + b*10 + c; }
static u8    bsub(u8 a, u8 b) __z88dk_fastcall { return (u8)(a - b); }
static u8    bfst(u8 a, u8 b) __z88dk_fastcall { return a; }
static void run(void){
  Assert(isub(50, 8) == 42, "isub");
  Assert(ifst(0x1234, 0x5678) == 0x1234, "ifst returns a");
  Assert(isnd(0x1234, 0x5678) == 0x5678, "isnd returns b");
  Assert(i3(1, 2, 3) == 123, "i3 three args");
  Assert(bsub(50, 8) == 42, "bsub");
  Assert(bfst(0xAB, 0xCD) == 0xAB, "bfst");
}
int main(int c,char**v){(void)c;(void)v;suite_setup("fcparam");suite_add_test(run);return suite_run();}
