/*
 *	Call a CPM BDOS routine
 *
 *	$Id: bdosh.c $
 */

#include <cpm.h>


int bdosh(int func,int arg)
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
#endasm
}
