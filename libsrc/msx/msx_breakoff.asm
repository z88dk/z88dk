;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_breakoff();
;
;	Disable BREAK
;
;
;	$Id: msx_breakoff.asm,v 1.1 2007-12-18 09:00:45 stefano Exp $
;

	XLIB	msx_breakoff
	XREF	brksave
	
        INCLUDE "#msxbasic.def"

msx_breakoff:
	ld	hl,BASROM	; disable Control-STOP
	ld	a,(hl)
	cp	1
	ret	z
	
	ld	(brksave),a
	ld	(hl),1
	ret
