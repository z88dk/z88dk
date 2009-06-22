;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_blank();
;
;	Disable screen
;
;	$Id: msx_blank.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_blank
	LIB	msxbios
	
        INCLUDE "msxbios.def"

msx_blank:

	ld	ix,DISSCR
	jp	msxbios
