/*
 *	Z88 Standard Library
 *
 *	long atol(char *str)
 *
 *	djm 25/2/2001
 *
 *	$Id: atol.c,v 1.1 2001-03-08 10:04:30 dom Exp $
 */

#include <stdlib.h>

static void atol2(long *ptr, char *s);

long atol(unsigned char *str)
{
	long	l;

	atol2(&l,str);
	return (l);
}

/*
int atol2(long *ptr, char *s)
*/
#asm
._atol2
	INCLUDE	"#integer.def"
	pop	bc	;ret address
	pop	hl	;string
	pop	de	;ptr
	push	de
	push	hl
	push	bc
	ld	b,254
	push	de
	call_oz(gn_gdn)
	pop	bc	;dest ptr
	ret	z	;was a number
; now set it equal to zero
	ld	hl,0
	ld	d,h
	ld	e,l
	jp	l_plong
#endasm
