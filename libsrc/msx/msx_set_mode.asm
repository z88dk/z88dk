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
;	$Id: msx_set_mode.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_set_mode
	PUBLIC	_msx_set_mode
	
	EXTERN	msxbios

        INCLUDE "msxbios.def"


msx_set_mode:
_msx_set_mode:
	push	ix
	push	hl
	pop	ix
	call	msxbios
	pop	ix
	ret

	;_init_sprites();
