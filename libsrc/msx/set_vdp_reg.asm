;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	void set_vdp_reg(int reg, int value);
;
;	Write data to a VDP register
;
;	$Id: set_vdp_reg.asm,v 1.1 2009-05-13 14:41:11 stefano Exp $
;

	XLIB	set_vdp_reg
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

set_vdp_reg:
	pop	hl
	pop	de
	pop	bc
	push	bc	; register
	push	de	; value
	push	hl	; RET address
	ld	b,e
	ld	ix,WRTVDP
	jp	msxbios

