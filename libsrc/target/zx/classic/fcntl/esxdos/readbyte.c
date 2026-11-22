

#include <fcntl.h>

int readbyte(int fd) __naked
{
#asm
     EXTERN	asm_esxdos_f_read
     ld     a,l
     push   ix
     push   bc	;space
     ld     hl,0
     add    hl,sp
     ld     bc,1
     call   asm_esxdos_f_read
     pop    bc 		; return
     pop    ix		; get users back
     ld     l,c
     ld     h,0
     ret    nc
     ld     hl,-1
     ret
#endasm
}
