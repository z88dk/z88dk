;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern int __FASTCALL__ msx_get_stick(unsigned char id);
;
;	get state of joystick number \a id
;
;	$Id: msx_get_stick.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;


	XLIB	msx_get_stick
	
	LIB	msxbios

        INCLUDE "#msxbios.def"


msx_get_stick:

	; __FASTCALL__ : stick id is already in L
	ld	a,l
	ld	ix,GTSTCK
	call	msxbios

	ld	h,0	
	ld	l, a

	ret
