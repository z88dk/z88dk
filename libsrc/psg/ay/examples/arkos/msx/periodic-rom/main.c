#include <intrinsic.h>
#include <stdint.h>

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
