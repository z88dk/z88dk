///////////////////////////////////////////////////////////////////////////////
//
// interrupt-ram.c - Example code for using interrupt-driven music playback
// with Arkos player running in RAM
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
// Compile with:
//   zcc +msx -vn interrupt-ram.c hocuspocus.asm -m -s --list -create-app -o arkos
//
///////////////////////////////////////////////////////////////////////////////

#include <intrinsic.h>
#include <stdint.h>
#include <interrupt.h>
#include <msx.h>

extern uint8_t song[];

void service_interrupt( void )
{
    ply_akg_play();
}

void init_interrupts( void ) {
    intrinsic_di();
    im1_init();
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
