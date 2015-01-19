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
;	$Id: set_vdp_reg.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	set_vdp_reg
	EXTERN	msxbios
	
        INCLUDE "msxbios.def"

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

