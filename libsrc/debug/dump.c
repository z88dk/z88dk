/*
 *	Memory Dump functions
 *
 *	Stefano 29/5/2002
 *
 *	$Id: dump.c,v 1.2 2002-06-10 10:14:07 stefano Exp $
 */

#include <stdio.h>
#include <debug.h>

void hexbyte (unsigned char mybyte);
void hexword (unsigned int myword);


unsigned int dump(unsigned int address, unsigned int count)
{

int x;	// unsigned int didn't work ...
if (address == 0xFFFF)
	{
#asm
	pop	hl
	pop	bc
	pop	de
	push	de
	push	bc
	push	hl
	ld	hl,8
	add	hl,sp
	push	hl
.sdloop
	push	de
	push	hl

	push	hl
	call	_hexword
	pop	hl

	ld	hl,':'
	push	hl
	call	fputc_cons
	pop	hl
	pop	hl
	push	hl

	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	bc
	call	_hexword
	pop	bc

	ld	hl,13
	push	hl
	call	fputc_cons
	pop	hl

	pop	hl
	pop	de
	inc	hl
	inc	hl
	dec	de
	ld	a,d
	or	e
	jr	nz,sdloop
	pop	hl
	pop	bc
	ret
#endasm
	}

	if ((address % 8) != 0)
	{
		fputc_cons(13);
		hexword (address);
	}

	for (x=address; x<address+count; x++)
	{
		if ((x % 8) == 0)
		{
			fputc_cons(13);
			hexword (x);
		}
		hexbyte (*x);
		fputc_cons(' ');
	}
	fputc_cons(13);
	return (x);

}



/* Address  */

void hexword (unsigned int myword)
{

		hexbyte ((unsigned char) (myword>>8));
		hexbyte ((unsigned char) myword);

		fputc_cons(' ');

}

void hexbyte (unsigned char mybyte)
{
#asm
	pop	hl
	pop	de
	push	de
	push	hl
	ld	a,e
	push	de
	srl	a
	srl	a
	srl	a
	srl	a
	ld	e,a

	ld	hl,hextab
	add	hl,de
	ld	a,(hl)
	ld	l,a
	ld	h,0

	push	hl
	call	fputc_cons
	pop	hl

	pop	de
	ld	a,e
	and	15
	ld	e,a

	ld	hl,hextab
	add	hl,de
	ld	a,(hl)
	ld	l,a
	ld	h,0

	push	hl
	call	fputc_cons
	pop	hl

	ret

.hextab	defm "0123456789ABCDEF"

#endasm
}
