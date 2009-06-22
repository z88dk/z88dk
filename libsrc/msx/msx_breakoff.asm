;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakoff();
;
;	Disable BREAK
;
;
;	$Id: msx_breakoff.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_breakoff
	XREF	brksave
	
        INCLUDE "msxbasic.def"

msx_breakoff:
	ld	hl,BASROM	; disable Control-STOP
	ld	a,(hl)
	cp	1
	ret	z
	
	ld	(brksave),a
	ld	(hl),1
	ret
