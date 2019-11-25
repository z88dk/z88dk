
#include <drivers/ioport.h>


/* void __FASTCALL__ IOPORT_read( unsigned int port ) */
char IOPORT_Read( char port )
{
#asm
    ld      hl,2
    add     hl,sp
    ld      c,(hl)
    in      l,(c)
    ld      h,0
#endasm
}
