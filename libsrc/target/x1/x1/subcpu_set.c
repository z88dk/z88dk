/*
 *	Sharp X1 Library
 *
 *	sent a byte parameter to the subcpu
 *
 *	Stefano Bodrato - 11/2013
 *
*/


#include <arch/x1.h>


extern void __FASTCALL__ subcpu_set(int command) {
	#asm
IBCK:
	LD	A,1AH
	IN	A,(1)
	AND	40H
	JR	NZ,IBCK
	LD	BC,1900H
	LD	A,L
	OUT	(C),A
	#endasm
}
