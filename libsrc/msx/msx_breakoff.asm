;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakoff();
;
;	Disable BREAK
;
;
;	$Id: msx_breakoff.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_breakoff
	PUBLIC	_msx_breakoff
	EXTERN	brksave
	
        INCLUDE "msxbasic.def"

msx_breakoff:
_msx_breakoff:
	ld	hl,BASROM	; disable Control-STOP
	ld	a,(hl)
	cp	1
	ret	z
	
	ld	(brksave),a
	ld	(hl),1
	ret
