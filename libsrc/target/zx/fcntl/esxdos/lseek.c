
#include <fcntl.h>

long lseek(int fd,long posn, int whence) __naked
{
#asm
     EXTERN asm_esxdos_f_seek
     push   ix	;save users
     ld     ix,2
     add    ix,sp
     ld     l,(ix+0)
     ld     e,(ix+2)
     ld     d,(ix+3)
     ld     c,(ix+4)
     ld     d,(ix+5)
     ld     a,(ix+6)
     call   asm_esxdos_f_seek
     pop    ix
     ret
#endasm
}
