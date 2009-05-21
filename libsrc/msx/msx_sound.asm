;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: msx_sound.asm,v 1.3 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_sound
	LIB     msxbios
	
IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
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
