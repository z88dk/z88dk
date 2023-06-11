

#include "test.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "zx.h"

static void dummy()
{
#asm
   ; Include old version
   INCLUDE "old/asm_zx_saddrpup.asm"

   ; Include new version
   INCLUDE "../../../libsrc/_DEVELOPMENT/arch/zx/display/z80/asm_zx_saddrpup.asm"
#endasm
}


static void evaluate(int y) __z88dk_fastcall __naked
{
#asm
    push   hl    ; Save for later
    ld     de,0
    push   de
    push   de
    pop    bc
    pop    af
    call   old_zx_saddrpup
    ld     (_old_regs+0),bc
    ld     (_old_regs+2),de
    ld     (_old_regs+4),hl
    push   af
    pop    hl
    ld     (_old_regs+6),hl
    pop    hl   ;Get argument back again
    ld     de,0
    push   de
    push   de
    pop    bc
    pop    af
    call   asm_zx_saddrpup
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
    int a;
    for ( a = 16384; a < 22528; a++ ) {
       evaluate(a);
       compare(a);
    }

}

int suite_pix()
{
    suite_setup("zx_saddrpup");

    suite_add_test(test_func);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_pix();

    exit(res);
}
