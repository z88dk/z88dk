;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: msx_sound.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msx_sound
	LIB     msxbios
	
        INCLUDE "#msxbios.def"

msx_sound:
	pop	hl
	pop	de	; value in E
	pop	bc
	push	bc
	pop	de
	pop	hl
	
	ld	a,c	; register number
	
	ld	ix,WRTPSG
	jp	msxbios
