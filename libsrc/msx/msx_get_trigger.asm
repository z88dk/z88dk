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
;	$Id: msx_get_trigger.asm,v 1.7 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_get_trigger
	PUBLIC	_msx_get_trigger

	EXTERN	msxbios

IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


msx_get_trigger:

	; __FASTCALL__ : stick id is already in L
	push	ix
	ld	a,l
	ld	ix,GTTRIG
	call	msxbios
	
	ld	h,0
	ld	l,a
	pop	ix	
	ret

