#include <intrinsic.h>
#include <stdint.h>

// If we are compiling for a ROM target we _have_ to use the ROM player by
// using this #define before the #include below:
//
// #define ARKOS_USE_ROM_PLAYER
//
// You can also define it adding -DARKOS_USE_ROM_PLAYER to the zcc compile
// command

#include <psg/arkos.h>


extern uint8_t song[];

void main( void ) {
    ply_akg_init( song, 0 );
    while ( 1 ) {
        (*(uint8_t *)0x4000)++;
        intrinsic_di();
        ply_akg_play();
        intrinsic_ei();
        intrinsic_halt();
    }
}
