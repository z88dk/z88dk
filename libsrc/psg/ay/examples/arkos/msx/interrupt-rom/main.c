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
        (*(uint8_t *)0x4000)++;	// show something on screen
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
        (*(uint8_t *)0x4020)++;	// show something on screen
                                // music playback should happen in interrupt context
    }
}
