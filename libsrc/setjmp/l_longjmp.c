/*
 *	longjmp(jmp_buf env, int val)
 *
 *	Return to a previous frame
 *
 *	djn 28/2/2000
 */

#include <setjmp.h>


void l_longjmp(jmp_buf *env, int val)
{
#pragma asm
	pop	de	;return address discarded
	pop	bc	;val
	ld	a,b
	or	c
	jr	nz,longjmp1
	inc	bc	;cant return 0
.longjmp1
	pop	hl	;&env
IF !__CPU_INTEL__ && !__CPU_GBZ80__
	ld	e,(hl)	;iy
	inc	hl
	ld	d,(hl)
	inc	hl
	push	de
	pop	iy
	ld	e,(hl)	;ix
	inc	hl
	ld	d,(hl)
	push	de
	pop	ix
ELSE
	inc	hl
	inc	hl
	inc	hl
ENDIF
	inc	hl
	ld	e,(hl)	;sp
	inc	hl
	ld	d,(hl)	
	inc	hl
	ld	a,(hl)	;pc
	inc	hl
	ld	h,(hl)
	ld	l,a	
	ex	de,hl
	ld	sp,hl
	push	de	;"&env"
	push	de	;ret address
	ld	l,c	;ret value
	ld	h,b
IF __CPU_GBZ80__
    ld  d,h
    ld  e,l
ENDIF
#pragma endasm
}

	
	
