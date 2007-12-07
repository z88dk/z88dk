;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	int msx_text();
;
;	Switch to text mode
;
;	$Id: msx_text.asm,v 1.2 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	msx_text
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

msx_text:
	ld	ix,TOTEXT
	jp	msxbios
