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
;	$Id: msx_set_mode.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


	XLIB	msx_set_mode
	
	LIB	msxbios

        INCLUDE "msxbios.def"


msx_set_mode:

	push	hl
	pop	ix
	jp	msxbios

	;_init_sprites();
