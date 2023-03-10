///////////////////////////////////////////////////////////////////////////////
//
// interrupt-rom.c - Example code for using interrupt-driven music playback
// with Arkos player running in ROM
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
// Compile with:
//   zcc +msx -subtype=rom -vn -DARKOS_USE_ROM_PLAYER interrupt-rom.c hocuspocus.asm -m -s --list -create-app -o arkos
//
///////////////////////////////////////////////////////////////////////////////

#include <intrinsic.h>
#include <stdint.h>
#include <interrupt.h>
#include <msx.h>

// If we are compiling for a ROM target we _have_ to use the ROM player by
// using this #define before the #include below:
//
// #define ARKOS_USE_ROM_PLAYER
//
// You can also define it adding -DARKOS_USE_ROM_PLAYER to the zcc compile
// command

#include <psg/arkos.h>

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
