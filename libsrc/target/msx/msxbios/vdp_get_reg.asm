;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;	Extended by Stefano Bodrato
;
;	int msx_getvdp(int reg);
;
;	Get a VDP register value
;
;	$Id: vdp_get_reg.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	vdp_get_reg
	PUBLIC	_vdp_get_reg


IF FORmsx
        INCLUDE "target/msx/def/msxbasic.def"
ELSE
        INCLUDE "target/svi/def/svibasic.def"
ENDIF

vdp_get_reg:
_vdp_get_reg:
	
	;;return *(u_char*)(0xF3DF + reg);
	
	; (FASTCALL) -> HL = address

IF FORmsx
	ld	de,RG0SAV
	add	hl,de
ELSE
	dec l
	ld	hl,RG0SAV
	jr	c,have_rg0
	ld	hl,RG1SAV
have_rg0:
ENDIF
	
	ld	l,(hl)
	ld	h,0
	ret

