;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakon();
;
;	Restore disabled BREAK
;
;
;	$Id: msx_breakon.asm,v 1.1 2007-12-18 09:00:45 stefano Exp $
;

	XLIB	msx_breakon
	XREF	brksave
	
        INCLUDE "#msxbasic.def"

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
