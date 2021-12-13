

#include "test.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "zx.h"

static void dummy()
{
#asm
   ; Include old version
   INCLUDE "old/asm_zx_saddrpright.asm"

   ; Include new version
   INCLUDE "../../../libsrc/_DEVELOPMENT/arch/zx/display/z80/asm_zx_saddrpright.asm"
#endasm
}


static void evaluate(int a, int m)  __naked
{
#asm
    ld     ix,2
    add    ix,sp
    ld     e,(ix+0)
    ld     d,0
    ld     l,(ix+2)
    ld     h,(ix+3)
    ld     bc,0
    push   bc
    pop    af
    call   old_zx_saddrpright
    ld     (_old_regs+0),bc
    ld     (_old_regs+2),de
    ld     (_old_regs+4),hl
    push   af
    pop    hl
    ld     (_old_regs+6),hl
    ld     ix,2
    add    ix,sp
    ld     e,(ix+0)
    ld     d,0
    ld     l,(ix+2)
    ld     h,(ix+3)
    ld     bc,0
    push   bc
    pop    af
    call   asm_zx_saddrpright
    ld     (_new_regs+0),bc
    ld     (_new_regs+2),de
    ld     (_new_regs+4),hl
    push   af
    pop    hl
    ld     (_new_regs+6),hl
    ret
#endasm
}

void test_func()
{
    int a = 16384;
    int e;
    
    for ( e = 1; e < 256; e <<= 1 ) {
       evaluate(a,e);
       compare(a);
    }
    e = 1;
    for ( a = 16385; a < 22528; a++ ) {
       evaluate(a,e);
       compare(a);
       e <<= 1;
       if ( e == 256 ) e = 1;
    }
}

int suite_pix()
{
    suite_setup("zx_saddrpright");

    suite_add_test(test_func);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_pix();

    exit(res);
}
