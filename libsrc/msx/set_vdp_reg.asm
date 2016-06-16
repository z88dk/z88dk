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
;	$Id: set_vdp_reg.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	set_vdp_reg
	PUBLIC	_set_vdp_reg
	EXTERN	msxbios
	
        INCLUDE "msxbios.def"

set_vdp_reg:
_set_vdp_reg:
	pop	hl
	pop	de
	pop	bc
	push	bc	; register
	push	de	; value
	push	hl	; RET address
	push	ix
	ld	b,e
	ld	ix,WRTVDP
	call	msxbios
	pop	ix
	ret

