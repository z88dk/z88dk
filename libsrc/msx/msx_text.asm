;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	int msx_text();
;
;	Switch to text mode
;
;	$Id: msx_text.asm,v 1.3 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_text
	LIB	msxbios
	
IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
ENDIF

msx_text:
	ld	ix,TOTEXT
	jp	msxbios
