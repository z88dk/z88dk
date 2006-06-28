;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 26/06/2006
;
;	int zx_128();
;
;	The result is:
;	- 0 (false) if the spectrum is a 48K
;	- 1 (true) if the spectrum is a Spectrum 128K
;
;	$Id: zx_128.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_128
	
zx_128:
	ld	hl,0
	ld	a,(75)
	cp	191
	ret	z
	inc	hl
	ret
