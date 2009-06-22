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
;	$Id: msx_vmerge.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;


	XLIB	msx_vmerge
	
IF FORmsx
        INCLUDE "msx.def"
ELSE
        INCLUDE "svi.def"
ENDIF


msx_vmerge:

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
