;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	void msx_setvdp(int reg, int value);
;
;	Write data to a VDP register
;
;	$Id: msx_set_vdp.asm,v 1.2 2009-04-15 21:00:58 stefano Exp $
;

	XLIB	msx_set_vdp
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

msx_set_vdp:
	pop	hl
	pop	de
	pop	bc
	push	bc	; register
	push	de	; value
	push	hl	; RET address
	ld	b,e
	ld	ix,WRTVDP
	jp	msxbios

