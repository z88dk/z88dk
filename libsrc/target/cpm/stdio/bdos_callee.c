/*
 *	Call a CPM BDOS routine
 *
 *	$Id: bdos_callee.c $
 */

#include <cpm.h>


int bdos_callee(int func,int arg)
{
#asm
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
