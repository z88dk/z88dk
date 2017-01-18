/*
 *	Sharp X1 Library
 *
 *	send a command to the subcpu
 *
 *	Stefano Bodrato - 11/2013
 *
*/

#include <x1.h>


extern void __FASTCALL__ subcpu_command(int command) {
	#asm
	ld	a,l
	push af
	call _wait_sub_cpu
	ld bc, $1900
	pop af
	out	(c),a
	call _wait_sub_cpu
	#endasm
}
