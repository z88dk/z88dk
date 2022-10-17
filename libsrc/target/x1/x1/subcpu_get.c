/*
 *	Sharp X1 Library
 *
 *	read a byte from the subcpu
 *
 *	Stefano Bodrato - 11/2013
 *
*/


#include <arch/x1.h>


extern int subcpu_get() {
	#asm
OBCK:
	LD	A,1AH
	IN	A,(1)
	AND	20H
	JR	NZ,OBCK
	LD	BC,1900H
	IN	A,(C)
	LD	H,C
	LD	L,A	
	#endasm
}
