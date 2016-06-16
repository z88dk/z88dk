;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_vpoke(int address, int value);
;
;	Improved functions by Rafael de Oliveira Jannone
;	Originally released in 2004 for GFX - a small graphics library
;
;	$Id: msx_vpoke.asm,v 1.8 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vpoke
	PUBLIC	_msx_vpoke
	EXTERN	msxbios
	
	INCLUDE	"msx/vdp.inc"


msx_vpoke:
_msx_vpoke:

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
	ld	a,l
	di
	out	(VDP_CMD), a
	ld	a,h
	and	@00111111
	or 	@01000000
	ei
	out	(VDP_CMD), a

	; enter data
	pop 	af
	out	(VDP_DATA), a

	ret
