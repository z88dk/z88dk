;
;	written by Benjamin Green, adapting code from Waleed Hasan
;
;	$Id: DsClearScreen.asm,v 1.4 2015-01-19 01:33:06 pauloscustodio Exp $
;

	PUBLIC	DsClearScreen


.DsClearScreen
	
;	in	a,(3)
;	ld	l,a
;	in	a,(4)
;	ld	h,a
;	push	hl

	ld	a,$10
	out	(4),a
	xor	a
	out	(3),a
	ld	de,$A001
	ld	h,d
	ld	l,a
	ld	bc,30*120-1
	ld	(hl),a
	ldir

;	pop	hl
;	ld	a,l
;	out	(3),a
;	ld	a,h
;	out	(4),a

	ret

