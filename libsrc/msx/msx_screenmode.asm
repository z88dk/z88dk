;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_screenmode();
;
;	Gets the current screen mode
;
;
;	$Id: msx_screenmode.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_screenmode
	
IF FORmsx
        INCLUDE "msxbasic.def"
ELSE
        INCLUDE "svibasic.def"
ENDIF

msx_screenmode:
	ld	a,(SCRMOD)
	ld	h,0
	ld	l,a
	ret
