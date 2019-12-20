/*
 *	Sharp X1 Library
 *
 *	8049 SUBCPU RESET
 *
 *	Stefano Bodrato - 2018
 *
*/


#include <x1.h>


extern void subcpu_reset() {
	#asm
	
		EXTERN	subcpu_command
		
S49RES:	LD	DE,0FF00H
RS49L1:	LD	BC,1A01H
	IN	A,(C)
	AND	20H
	JR	Z,OBF1IN
	DEC	DE
	LD	A,D
	OR	E
	JR	NZ,RS49L1
	JR	RS49L2
OBF1IN:	LD	BC,1900H
INLOP:	IN	A,(C)
	JR	S49RES
RS49L2:	LD	B,8
OUTLP:	LD	L,0
	PUSH	BC
	CALL	subcpu_command
	POP		BC
	DJNZ	OUTLP
	#endasm
}
