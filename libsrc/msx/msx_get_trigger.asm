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
;	$Id: msx_get_trigger.asm,v 1.1 2009-01-07 09:50:15 stefano Exp $
;


	XLIB	msx_get_trigger
	XDEF	_st_dir

	LIB	msxbios

        INCLUDE "#msxbios.def"


msx_get_trigger:

	; __FASTCALL__ : stick id is already in L
	ld	a,l
	ld	ix,GTTRIG
	call	msxbios
	
	ld	h,0
	ld	l, a
	
	ret

	
._st_dir
	defb @0000 ; 0
	defb @0001 ; 1
	defb @0011 ; 2
	defb @0010 ; 3
	defb @0110 ; 4
	defb @0100 ; 5
	defb @1100 ; 6
	defb @1000 ; 7
	defb @1001 ; 8
