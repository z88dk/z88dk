;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_screenmode();
;
;	Gets the current screen mode
;
;
;	$Id: msx_screenmode.asm,v 1.2 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_screenmode
	
IF FORmsx
        INCLUDE "#msxbasic.def"
ELSE
        INCLUDE "#svibasic.def"
ENDIF

msx_screenmode:
	ld	a,(SCRMOD)
	ld	h,0
	ld	l,a
	ret
