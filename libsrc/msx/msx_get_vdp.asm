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
;	$Id: msx_get_vdp.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;

	XLIB	msx_get_vdp
	

msx_get_vdp:
	
	;;return *(u_char*)(0xF3DF + reg);
	
	; (FASTCALL) -> HL = address

	ld	de,$f3df
	add	hl,de
	
	ld	a,(hl)
	
	ld	h,0
	ld	l,a
	ret
