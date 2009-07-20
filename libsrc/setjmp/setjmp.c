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
	pop	de	;&env
	ld	hl,0
	add	hl,sp	;stack pointer
	ex	de,hl
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

