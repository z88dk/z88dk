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
	PUBLIC	st_dir
	PUBLIC	_st_dir
	
	EXTERN	msxbios

st_dir:
_st_dir:
	defw @0000 ; 0
	defw @0001 ; 1
	defw @0011 ; 2
	defw @0010 ; 3
	defw @0110 ; 4
	defw @0100 ; 5
	defw @1100 ; 6
	defw @1000 ; 7
	defw @1001 ; 8

IF FORm5

	INCLUDE "target/m5/def/m5bios.def"

msx_get_stick:
_msx_get_stick:

	call	JOYSP
	ld	h,0
	ld	l,a
	ret

ELSE
IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
ENDIF


msx_get_stick:
_msx_get_stick:

	; __FASTCALL__ : stick id is already in L
	push	ix
	ld	a,l
	ld	ix,GTSTCK
	call	msxbios

	ld	h,0	
	ld	l,a
	pop	ix
	ret
ENDIF
