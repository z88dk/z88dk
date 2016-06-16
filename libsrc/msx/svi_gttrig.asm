;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	GTTRIG
;
;
;	$Id: svi_gttrig.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	GTTRIG
	
	EXTERN	svi_slstick


        INCLUDE "svi.def"

	
GTTRIG:
	dec	a
	jp	m,getspace

	push	af
	and	1
	
	call	svi_slstick
	
	pop	bc
	dec	b
	dec	b
	ld	b,$10
	jp	m,trig1
	ld	b,' '
trig1:	and	b
trig2:	sub	1	; 255 if a=0, otherwise 0
	sbc	a,a
	ret

getspace:
	di
	in	a,(PPI_C)
	and	$f0
	ld	c,a
	add	8		; keyboard row #8
	out	(PPI_COUT),a
	in	a,(PPI_B)	; bits: RDULxxxF  Fire is the SPACE key
	ei

	and	1
	jr	trig2

