;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_screenmode();
;
;	Gets the current screen mode
;
;
;	$Id: msx_screenmode.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_screenmode
	PUBLIC	_msx_screenmode
	
IF FORmsx
        INCLUDE "msxbasic.def"
ELSE
        INCLUDE "svibasic.def"
ENDIF

msx_screenmode:
_msx_screenmode:
	ld	a,(SCRMOD)
	ld	h,0
	ld	l,a
	ret
