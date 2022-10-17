/*
 *	Sharp X1 Library
 *
 *	send a command to the subcpu
 *
 *	Stefano Bodrato - 11/2013
 *
*/


#include <arch/x1.h>


extern void __FASTCALL__ subcpu_command(int command) {
	#asm
	CALL IBCK
	LD	BC,1900H
	LD	A,L
	OUT	(C),A
IBCK:
	LD	A,1AH
	IN	A,(1)
	AND	40H
	JR	NZ,IBCK
	#endasm
}
