/*
 *	Call a CPM BDOS routine
 *
 *	$Id: bdos.c,v 1.1 2002-01-27 21:28:48 dom Exp $
 */

#include <cpm.h>


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
IF !__CPU_INTEL__
	push	ix
	call	5
	pop	ix
ELSE
	call	5
ENDIF
	ld	l,a
	rla		;make -ve if error
	sbc	a,a
	ld	h,a
#endasm
}
