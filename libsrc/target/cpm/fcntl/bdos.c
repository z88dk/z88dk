/*
 *	Call a CPM BDOS routine
 *
 *	$Id: bdos.c $
 */

#include <cpm.h>


int bdos(int func,int arg)
{
#asm
	EXTERN __bdos

	ld	hl,2
	add	hl,sp
	ld	e,(hl)	;arg
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	c,(hl)	;func
	call __bdos
	ld	l,a
	rla		;make -ve if error
	sbc	a,a
	ld	h,a
#endasm
}
