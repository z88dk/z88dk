;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/06/2006
;
;	int zx_issue3();
;
;	The result is:
;	- 0 (false) if the spectrum is issue 1 or 2.
;	- 1 (true) if the spectrum is an "issue 3" or more
;
;	$Id: zx_issue3.asm,v 1.3 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_issue3
	
zx_issue3:
	ld	a,(23624)  
	rrca
	rrca
	rrca
	or	8
	out	(254),a

	ld	bc,57342
	in	a,(c)
	in	a,(c)
	ld	hl,1		; true
	xor	255
	ret	nz
	dec	hl
	ret
