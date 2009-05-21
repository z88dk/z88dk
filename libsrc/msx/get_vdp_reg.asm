;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	int msx_getvdp(int reg);
;
;	Get a VDP register value
;
;	$Id: get_vdp_reg.asm,v 1.2 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	get_vdp_reg
	

get_vdp_reg:
	
IF FORmsx
	;;return *(u_char*)(0xF3DF + reg);
	
	; (FASTCALL) -> HL = address

	ld	de,$f3df
	add	hl,de
	
	ld	a,(hl)
	
	ld	h,0
	ld	l,a
	ret

ELSE
	ld	a,($FE3C)	; Spectravideo keeps only value for register #0
	ld	h,0
	ld	l,a
	ret
ENDIF
