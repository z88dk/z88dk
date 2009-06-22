;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: msx_sound.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_sound
	LIB     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_sound:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
	ld	a,l
	
	ld	ix, WRTPSG
	jp	msxbios
