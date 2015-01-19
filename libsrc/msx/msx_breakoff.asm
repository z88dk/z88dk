;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakoff();
;
;	Disable BREAK
;
;
;	$Id: msx_breakoff.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_breakoff
	EXTERN	brksave
	
        INCLUDE "msxbasic.def"

msx_breakoff:
	ld	hl,BASROM	; disable Control-STOP
	ld	a,(hl)
	cp	1
	ret	z
	
	ld	(brksave),a
	ld	(hl),1
	ret
