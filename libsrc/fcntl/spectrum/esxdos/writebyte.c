

#include <fcntl.h>

int writebyte(int handle, int c) __naked
{
#asm
     EXTERN	asm_esxdos_f_write
     pop    bc
     pop    hl  ; c
     pop    de  ; handle
     push   de
     push   hl
     push   bc
     ld     a,e	; handle
     ld     hl,2
     add    hl,sp	;source
     ld     bc,1	;number of bytes
     push   ix		;save users
     call   asm_esxdos_f_write
     pop    ix
     ret    nc		;hl= number of bytes written
     ld     hl,-1
     ret
#endasm
}
