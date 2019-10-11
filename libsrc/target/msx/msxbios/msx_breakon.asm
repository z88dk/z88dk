;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakon();
;
;	Restore disabled BREAK
;
;
;	$Id: msx_breakon.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_breakon
	PUBLIC	_msx_breakon
	EXTERN	brksave
	
        INCLUDE "target/msx/def/msxbasic.def"

msx_breakon:
_msx_breakon:
	ld	hl,BASROM
	ld	a,(hl)
	cp	1
	ret	nz	; Already enabled ?
	
	; Ok, we have something to restore
	ld	a,(brksave)
	ld	(hl),a
	ret
