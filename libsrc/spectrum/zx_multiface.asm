;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_multiface();
;
;	The result is:
;	- 1 (true) if the MultiFace is connected
;	- 0 (false) otherwise
;
;	$Id: zx_multiface.asm,v 1.1 2006-12-01 16:58:30 stefano Exp $
;

	XLIB	zx_multiface
	
zx_multiface:
	ld	hl,0
	in	a,($bf)
	in	a,($9f)
	ld	a,(200)
	ld	b,a
	in	a,($3f)
	in	a,($1f)
	ld	a,(200)
	cp	b
	ret	z

	inc	hl
	ret
