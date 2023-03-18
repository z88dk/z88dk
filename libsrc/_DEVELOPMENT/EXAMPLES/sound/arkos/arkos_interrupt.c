///////////////////////////////////////////////////////////////////////////////
//
// arkos_interrupt.c - Example code for using interrupt-driven music playback
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
// Compile:
//   zcc +zx -vn -clib=new arkos_interrupt.c -o arkint -create-app
//   zcc +zx -vn -clib=sdcc_ix arkos_interrupt.c -o arkint -create-app
//   zcc +zx -vn -clib=sdcc_iy arkos_interrupt.c -o arkint -create-app
//
// Add -DUSE_ARKOS_ROM_PLAYER to any of the above if you want to use the ROM
// (non SMC) player:
//
//   zcc +zx -vn -DUSE_ARKOS_ROM_PLAYER -clib=new arkos_interrupt.c -o arkromint -create-app
//   zcc +zx -vn -DUSE_ARKOS_ROM_PLAYER -clib=sdcc_ix arkos_interrupt.c -o arkromint -create-app
//   zcc +zx -vn -DUSE_ARKOS_ROM_PLAYER -clib=sdcc_iy arkos_interrupt.c -o arkromint -create-app
//
///////////////////////////////////////////////////////////////////////////////

#include <intrinsic.h>
#include <stdint.h>
#include <im2.h>
#include <string.h>
#include <z80.h>

#ifdef __SPECTRUM__
#include <arch/spectrum.h>
#endif

#include <sound/arkos.h>

extern uint8_t song[];

void wrapper() __naked
{
__asm
   INCLUDE "hocuspocus.asm"
__endasm;
}

IM2_DEFINE_ISR(service_interrupt)
{
    ply_akg_play();
}

#define IV_ADDR         ( ( unsigned char * ) 0xD000 )
#define ISR_ADDR        ( ( unsigned char * ) 0xD1D1 )
#define IV_BYTE         ( 0xD1 )
#define Z80_OPCODE_JP   ( 0xc3 )

void init_interrupts( void ) {
    intrinsic_di();
    memset( IV_ADDR, IV_BYTE, 257);
    z80_bpoke( ISR_ADDR, Z80_OPCODE_JP );
    z80_wpoke( ISR_ADDR + 1, (uint16_t) service_interrupt );
    im2_init( IV_ADDR );
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
