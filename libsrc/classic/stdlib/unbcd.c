/*
 *	Decode from BCD to unsigned int
 *
 *	$Id: unbcd.c,v 1.1 2013-11-13 20:56:44 stefano Exp $
 */
#include <stdlib.h>

unsigned int unbcd(unsigned int value) __naked {
#asm
#ifdef RCMX000
	ld	hl,(sp+2)
#else
	pop	bc
	pop	hl	;value
	push	hl
	push	bc
	push	hl	;save value
#endif
	ld	a,h
	rra
	rra
	rra
	rra
	and	15
	ld	l,a
	ld	h,0
	ld	de,1000
	call	l_mult
#ifdef RCMX000
	push	hl
	ld	hl,(sp+4)
#else
	ex	de,hl
	pop	hl	;get value back
	push	de	;save result
	push	hl	;save value
#endif
	ld	a,h
	and	15
	ld	l,a
	ld	h,0
	ld	de,100
	call	l_mult
#ifdef RCMX000
	push	hl
	ld	hl,(sp+6)
#else
	ex	de,hl
	pop	hl	;get value back
	push	de	;save result
	push	hl	;save value
#endif
	ld	a,l
	rra
	rra
	rra
	rra
	and	15
	ld	l,a
	ld	h,0
	ld	de,10
	call	l_mult
#ifdef RCMX000
	push	hl
	ld	hl,(sp+8)
#else
	ex	de,hl
	pop	hl	;get result back
	push	de	;save result
#endif
	ld	a,l
	and	15
	ld	l,a
	ld	h,0
	pop	de	;10s
	add	hl,de
	pop	de	;100s
	add	hl,de
	pop	de	;1000s
	add	hl,de
	ret
#endasm
}


