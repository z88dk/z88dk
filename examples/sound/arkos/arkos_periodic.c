///////////////////////////////////////////////////////////////////////////////
//
// arkos_periodic.c - Example code for using loop driven music playback with
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
///////////////////////////////////////////////////////////////////////////////

#include <intrinsic.h>
#include <stdint.h>

#include <psg/arkos.h>

extern uint8_t song[];

void wrapper() __naked
{
__asm
   INCLUDE "hocuspocus.asm"
__endasm;
}


void main( void ) {
    ply_akg_init( song, 0 );
    while ( 1 ) {
        intrinsic_di();
        ply_akg_play();
        intrinsic_ei();
        intrinsic_halt();
        // do whatever in your main loop
    }
}
