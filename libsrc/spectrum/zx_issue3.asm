;
;	ZX Spectrum specific routines
;
;	int zx_issue3();
;
;	The result is:
;	- 0 (false) if the spectrum is issue 1 or 2.
;	- 1 (true) if the spectrum is an "issue 3" or more
;
;	$Id: zx_issue3.asm,v 1.1 2006-05-23 21:47:26 stefano Exp $
;

	XLIB	zx_issue3
	
zx_issue3:
	ld	bc,57342
	in	a,(c)
	and	@11000000
	ld	hl,1		; true
	cp	@11000000
	ret	z
	ld	l,0		; false
	ret
