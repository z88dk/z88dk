;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern void vmerge(unsigned int addr, unsigned char value);
;
;	set \a value at a given vram address \a addr, merging bits (OR) with the existing value
;
;	$Id: msx_vmerge.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_vmerge
	PUBLIC	_msx_vmerge
	
	INCLUDE	"msx/vdp.inc"


msx_vmerge:
_msx_vmerge:

	; enter vdp address pointer

	pop	bc
	pop	de
	pop	hl
	push	hl	; addr
	push	de	; value
	push	bc	; RET address

	ld	c,VDP_CMD
	ld	b,c

	di
	out	(c),l
	ld	a,h
	and	@00111111
	ei
	out	(c),a

	; read data

	ld	c,VDP_DATAIN
	in	h,(c)
	ld	c,b

	; enter same address

	di
	out	(c),l
	or	@01000000
	ei
	out	(c),a

	ld	a,e
	out	(VDP_DATA), a

	ret
