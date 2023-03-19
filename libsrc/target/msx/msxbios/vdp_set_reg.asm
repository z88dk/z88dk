;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	void vdp_set_reg(int reg, int value);
;
;	Write data to a VDP register
;
;	$Id: vdp_set_reg.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_set_reg
	PUBLIC	_vdp_set_reg
	EXTERN	msxbios
	
IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF

vdp_set_reg:
_vdp_set_reg:
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

