;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	GTTRIG
;
;
;	$Id: svi_gttrig.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	GTTRIG
	
	LIB	svi_kbdstick
	LIB	svi_slstick


IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF


	
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
	call	svi_kbdstick
	and	1
	jr	trig2

