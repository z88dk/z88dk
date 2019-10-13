#include <stdio.h>
#include <string.h>
#include <drivers/ioport.h>
#include <drivers/keyboard.h>
#include <ATJ2085_Ports.h>

void KEYBOARD_ISR( void ) {
#asm
	ld	a, MINT_STATUS_KEYBOARD
	out     (MINT_STATUS_REG), a
#endasm
}
