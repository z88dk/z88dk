;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_blank();
;
;	Disable screen
;
;	$Id: msx_blank.asm,v 1.2 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	msx_blank
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

msx_blank:

	ld	ix,DISSCR
	jp	msxbios
