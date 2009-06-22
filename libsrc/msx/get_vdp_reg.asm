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
;	$Id: get_vdp_reg.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	get_vdp_reg


IF FORmsx
        INCLUDE "msxbasic.def"
ELSE
        INCLUDE "svibasic.def"
ENDIF

get_vdp_reg:
	
	;;return *(u_char*)(0xF3DF + reg);
	
	; (FASTCALL) -> HL = address

IF FORmsx
	ld	de,RG0SAV
ELSE
	ld	de,RG0SAV
ENDIF
	add	hl,de
	
	ld	a,(hl)
	
	ld	h,0
	ld	l,a
	ret

	ld	h,0
	ld	l,a
	ret
