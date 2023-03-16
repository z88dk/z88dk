///////////////////////////////////////////////////////////////////////////////
//
// arkos_periodic.c - Example code for using loop driven music playback with
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
// Compile:
//   zcc +zx -vn -clib=new arkos_periodic.c -o arkper -create-app
//   zcc +zx -vn -clib=sdcc_ix arkos_periodic.c -o arkper -create-app
//   zcc +zx -vn -clib=sdcc_iy arkos_periodic.c -o arkper -create-app
//
// Add -DUSE_ARKOS_ROM_PLAYER to any of the above if you want to use the ROM
// (non SMC) player:
//
//   zcc +zx -vn -DUSE_ARKOS_ROM_PLAYER -clib=new arkos_periodic.c -o arkromper -create-app
//   zcc +zx -vn -DUSE_ARKOS_ROM_PLAYER -clib=sdcc_ix arkos_periodic.c -o arkromper -create-app
//   zcc +zx -vn -DUSE_ARKOS_ROM_PLAYER -clib=sdcc_iy arkos_periodic.c -o arkromper -create-app
//
///////////////////////////////////////////////////////////////////////////////

#include <intrinsic.h>
#include <stdint.h>

#include <sound/arkos.h>

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
