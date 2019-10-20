/* 03/03/2006 23:08: fc: first version */

#include <ATJ2085_Ports.h>
#include <drivers/keyboard.h>

void KEYBOARD_Initialise( void ) {
#asm
	ld      a, KEYSCAN_CTRL_ENABLE | KEYSCAN_CTRL_MASK_KEYIN1
	out     (KEYSCAN_CTRL_REG), a

	in      a, (MINT_ENABLE_REG)
	or      a, MINT_ENABLE_KEYBOARD
	out     (MINT_ENABLE_REG), a
#endasm
}
