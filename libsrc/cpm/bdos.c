/*
 *	Call to CP/M bdos
 */


#include <stdio.h>


int bdos(int func,int arg)
{
#asm
	ld	hl,2
	add	hl,sp
	ld	e,(hl)	;arg
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)	;func
	call	5
	ld	l,a
	rla		;make -ve if error
	sbc	a,a
	ld	h,a
#endasm
}
