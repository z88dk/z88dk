#define ANSI_STDIO

#include <stdio.h>


/*
 * Cheating somewhat, this will cause a barf in the compiler...bigtime..
 * nevermind...
 */

// int vfprintf_mini(FILE *fp, unsigned char *fmt,void *ap)

int printf(char *fmt,...)
{
#asm
	EXTERN	vfprintf
	EXTERN	__sgoioblk
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,sp

	ld	bc,__sgoioblk+10
	push	bc
	ld	e,(hl)	;fmt
	inc	hl
	ld	d,(hl)
	dec	hl
	dec	hl
	dec	hl
	push	de
	push	hl
	call	vfprintf
	pop	bc
	pop	bc
	pop	bc	
#endasm
}
