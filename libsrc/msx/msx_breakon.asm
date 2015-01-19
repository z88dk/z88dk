;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakon();
;
;	Restore disabled BREAK
;
;
;	$Id: msx_breakon.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_breakon
	EXTERN	brksave
	
        INCLUDE "msxbasic.def"

msx_breakon:
	ld	hl,brksave
	ld	a,(hl)
	cp	1
	ret	nz	; Already enabled ?
	
	; Ok, we have something to restore
	ld	(BASROM),a
	ld	a,1	; update the flag
	ld	(hl),a
	ret
