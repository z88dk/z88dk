;
;	ZX Spectrum specific routines
;
;	int zx_issue();
;
;	The result is:
;	- 2 if the spectrum is issue 1 or 2.
;	- 3 if the spectrum is an "issue 3" or more
;
;	$Id: zx_issue.asm,v 1.1 2005-11-21 11:49:40 stefano Exp $
;

	XLIB	zx_issue
	
zx_issue:
	ld	bc,57342
	in	a,(c)
	and	@11000000
	ld	hl,3
	cp	@11000000
	ret	z
	ld	l,2
	ret
