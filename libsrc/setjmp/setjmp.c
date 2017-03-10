/*
 *	setjmp(jmp_buf env)
 *
 *	djm 28/2/2000
 *
 *	We have no register vars so only need to
 *	save sp and return PC
 */


#include <setjmp.h>


int setjmp(jmp_buf env)
{
#pragma asm
	pop	bc	;return address
	pop	hl	;&env
	push	iy
	pop	de	;de=iy, hl=&env
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	push	ix
	pop	de	;de=ix, hl=&env
	ld	(hl),e
	inc	hl
	ld	(hl),d
	inc	hl
	ex	de,hl	;de=&env, hl=scratch
	ld	hl,0
	add	hl,sp	;stack pointer
	ex	de,hl	;hl=env+2, de=sp
	ld	(hl),e	;sp
	inc	hl
	ld	(hl),d
	inc	hl
	ld	(hl),c	;pc
	inc	hl
	ld	(hl),b	
	push	de
	push	bc

	ld	hl,0	;Have to return 0
#pragma endasm
}

