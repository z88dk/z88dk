;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern bool __FASTCALL__ msx_get_trigger(unsigned char id);
;
;	get state of joystick button (trigger) number \a id, true = pressed
;
;	$Id: msx_get_trigger.asm,v 1.5 2009-06-22 21:44:17 dom Exp $
;


	XLIB	msx_get_trigger

	LIB	msxbios

IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


msx_get_trigger:

	; __FASTCALL__ : stick id is already in L
	ld	a,l
	ld	ix,GTTRIG
	call	msxbios
	
	ld	h,0
	ld	l,a
	
	ret

