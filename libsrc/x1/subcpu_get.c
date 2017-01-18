/*
 *	Sharp X1 Library
 *
 *	read a byte from the subcpu
 *
 *	Stefano Bodrato - 11/2013
 *
*/


#include <x1.h>


extern int subcpu_get() {
	#asm
	ld bc, $1900
	in	a,(c)
	ld	h,0
	ld	l,a
	#endasm
}
