/*
 *	Call a CPM BDOS routine
 *
 *	$Id: bdosh_callee.c $
 */

#include <cpm.h>


int bdosh_callee(int func,int arg)
{
#asm
	EXTERN __bdos
;	ld	hl,2
;	add	hl,sp
;	ld	e,(hl)	;arg
;	inc	hl
;	ld	d,(hl)
;	inc	hl
;	ld	c,(hl)	;func
	
	pop	hl
	pop de
	pop bc
	push hl
	
	call __bdos
	ld	l,a
#endasm
}
