;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_vpoke(int address, int value);
;
;	Improved functions by Rafael de Oliveira Jannone
;	Originally released in 2004 for GFX - a small graphics library
;
;	$Id: msx_vpoke.asm,v 1.3 2009-01-07 09:50:15 stefano Exp $
;

	XLIB	msx_vpoke
	LIB	msxbios
	
        ;INCLUDE "#msxbios.def"
        INCLUDE "#msx.def"


msx_vpoke:

	pop	bc
	pop	de
	pop	hl
	push	hl	; VRAM address
	push	de	; value
	push	bc	; RET address
	ld	a,e
	;ld	ix,WRTVRM
	;jp	msxbios

	; enter vdp address pointer
	push	af
	ld a,l
	di
	out (VDP_CMD), a
	ld a,h
	and @00111111
	or  @01000000
	ei
	out (VDP_CMD), a

	; enter data
	pop  af
	out (VDP_DATA), a

	ret
