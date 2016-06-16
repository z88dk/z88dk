;
;	MSX specific routines
;
;	GFX - a small graphics library 
;	Copyright (C) 2004  Rafael de Oliveira Jannone
;
;	extern int __FASTCALL__ msx_get_stick(unsigned char id);
;
;	Get state of a specified joystick number id
;
;	$Id: msx_get_stick.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_get_stick
	PUBLIC	_msx_get_stick
	PUBLIC	_st_dir
	
	EXTERN	msxbios

IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

_st_dir:
	defb @0000 ; 0
	defb @0001 ; 1
	defb @0011 ; 2
	defb @0010 ; 3
	defb @0110 ; 4
	defb @0100 ; 5
	defb @1100 ; 6
	defb @1000 ; 7
	defb @1001 ; 8


msx_get_stick:
_msx_get_stick:

	; __FASTCALL__ : stick id is already in L
	push	ix
	ld	a,l
	ld	ix,GTSTCK
	call	msxbios

	ld	h,0	
	ld	l, a
	pop	ix
	ret
