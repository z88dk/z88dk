#include <fcntl.h>

int close(int handle) __naked
{
#asm
        EXTERN   asm_esxdos_f_close
        pop      bc
        pop      hl
        push     hl
        push     bc
        push     ix
        call     asm_esxdos_f_close
        pop      ix
        ret
#endasm
}


