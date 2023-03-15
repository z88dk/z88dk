///////////////////////////////////////////////////////////////////////////////
//
// arkos_rominterrupt.c - Example code for using interrupt-driven music playback
// Uses ROMable player
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
///////////////////////////////////////////////////////////////////////////////

#define ARKOS_USE_ROM_PLAYER 1

#include <intrinsic.h>
#include <stdint.h>
#include <interrupt.h>

#ifdef __SPECTRUM__
#include <spectrum.h>
#endif
#ifdef __MSX__
#include <msx.h>
#endif
#ifdef __CPC__
#include <cpc.h>
#endif

#include <psg/arkos.h>

extern uint8_t song[];

void wrapper() __naked
{
__asm
   INCLUDE "hocuspocus.asm"
__endasm;
}

void service_interrupt( void )
{
    M_PRESERVE_ALL;
    ply_akg_play();
    M_RESTORE_ALL;
}

void init_interrupts( void ) {
    intrinsic_di();
#if __SPECTRUM__
    zx_im2_init(0xd300, 0xd4);
   add_raster_int(0x38);
#endif
#ifndef NO_INTERRUPT_INIT
   im1_init();
#endif
    add_raster_int( service_interrupt );
    intrinsic_ei();
}


void main( void ) {
    ply_akg_init( song, 0 );
    init_interrupts();
    while ( 1 ) {
        // do whatever in your main loop
        // music playback should happen in interrupt context
    }
}
