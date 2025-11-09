
#include <fcntl.h>

long lseek(int fd,long posn, int whence) __z88dk_saveframe
{
#asm
     EXTERN asm_esxdos_f_seek
     ; lseek() is marked as saveframe so no need to explictly push
     ld     ix,2
     add    ix,sp
     ld     l,(ix+0)
     ld     e,(ix+2)
     ld     d,(ix+3)
     ld     c,(ix+4)
     ld     b,(ix+5)
     ld     a,(ix+6)
     call   asm_esxdos_f_seek
#endasm
}
