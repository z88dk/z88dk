;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.1 2013-11-15 10:59:30 stefano Exp $
;

	XLIB	set_psg
	LIB     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
	ld	a,l
	
	ld	ix, WRTPSG
	jp	msxbios
