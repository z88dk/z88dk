;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern bool __FASTCALL__ msx_set_mode(unsigned char id);
;
;	set screen mode
;
;	$Id: msx_set_mode.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;


	XLIB	msx_set_mode
	
	LIB	msxbios

        INCLUDE "#msxbios.def"


msx_set_mode:

	push	hl
	pop	ix
	jp	msxbios

	;_init_sprites();
