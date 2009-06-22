;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	int msx_text();
;
;	Switch to text mode
;
;	$Id: msx_text.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_text
	LIB	msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_text:
	ld	ix,TOTEXT
	jp	msxbios
