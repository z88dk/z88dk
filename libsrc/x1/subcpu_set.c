/*
 *	Sharp X1 Library
 *
 *	sent a byte parameter to the subcpu
 *
 *	Stefano Bodrato - 11/2013
 *
*/


#include <x1.h>

extern void __FASTCALL__ subcpu_set(int command) {
	#asm
	ld	a,l
	ld bc, $1900
	out (c),a
	#endasm
}
