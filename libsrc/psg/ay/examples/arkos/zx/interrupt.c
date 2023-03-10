///////////////////////////////////////////////////////////////////////////////
//
// interrupt.c - Example code for using interrupt driven music playback with
// Arkos player
//
// 10/03/2023 - ZXjogv <zx@jogv.es>
//
// Compile with:
//   zcc +zx -vn interrupt.c hocuspocus.asm -m -s --list -create-app -o arkos
//
///////////////////////////////////////////////////////////////////////////////

#include <intrinsic.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <im2.h>

#include <psg/arkos.h>

extern uint8_t song[];

M_BEGIN_ISR(isr)
{
    (*(uint8_t *)0x4020)++;
    ply_akg_play();
}
M_END_ISR

#define JP_OPCODE 195

void init_interrupts( void ) {
    intrinsic_di();
    im2_Init( ( void * ) 0xd300 );                // place z80 in im2 mode with interrupt vector table located at 0xd300
    memset( ( void * ) 0xd300, 0xd4, 257 );       // initialize 257-byte im2 vector table with all 0xd4 bytes
    bpoke( ( void * ) 0xd4d4, JP_OPCODE );        // POKE jump instruction at address 0xd4d4 (interrupt service routine entry)
    wpoke( ( void * )0xd4d5, ( uint16_t ) isr );              // POKE isr address following the jump instruction
    intrinsic_ei();
}

void main( void ) {
    ply_akg_init( song, 0 );
    init_interrupts();
    while ( 1 ) {
        // show something on screen
        (*(uint8_t *)0x4000)++;
    }
}
