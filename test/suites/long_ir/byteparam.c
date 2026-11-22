#include "test.h"
typedef unsigned char u8;
u8 zf, cf;
static u8 cond2(u8 b) __z88dk_fastcall {
    switch (b & 0x0f) {
    case 2: return (u8)((zf | cf) ^ 0xff);
    case 5: return cf;
    case 7: return zf;
    default: return 0;
    }
}
static u8 addp(u8 x) __z88dk_fastcall { return (u8)(x + zf); }  /* byte param + global */
static void run(void){
    zf = 0x0C; cf = 0x30;
    Assert(cond2(2) == (u8)((0x0C|0x30)^0xff), "cond2 case2");
    Assert(cond2(5) == 0x30, "cond2 case5 (cf)");
    Assert(cond2(7) == 0x0C, "cond2 case7 (zf)");
    Assert(cond2(1) == 0, "cond2 default");
    Assert(addp(0x05) == (u8)(0x05+0x0C), "addp");
}
int main(int c,char**v){(void)c;(void)v;suite_setup("byte-param autopush");suite_add_test(run);return suite_run();}
