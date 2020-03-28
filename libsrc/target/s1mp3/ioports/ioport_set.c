
#include <drivers/ioport.h>

/*void __FASTCALL__ IOPORT_set( unsigned int port, unsigned int data )*/
void IOPORT_Set( char port, char value )
{
#asm
        push    ix
        ld      ix,4
        add     ix,sp
        ld      c,(ix+0)
        ld      a,(ix+2)
        out     (c),a
        pop     ix
#endasm     
}

