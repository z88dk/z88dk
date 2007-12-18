;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_screenmode();
;
;	Gets the current screen mode
;
;
;	$Id: msx_screenmode.asm,v 1.1 2007-12-18 09:00:46 stefano Exp $
;

	XLIB	msx_screenmode
	
        INCLUDE "#msxbasic.def"

msx_screenmode:
	ld	a,(SCRMOD)
	ld	h,0
	ld	l,a
	ret
