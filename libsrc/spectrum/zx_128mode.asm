;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 26/06/2006
;
;	int zx_128mode();
;
;	The result is:
;	- 0 (false) if the spectrum is not a ZX128 or if it is in 48K mode
;	- 1 (true) if the spectrum is a Spectrum 128K in 128K mode
;
;	$Id: zx_128mode.asm,v 1.1 2006-06-28 22:21:26 stefano Exp $
;

	XLIB	zx_128mode
	
zx_128mode:
	ld	hl,0
	ld	a,(75)
	cp	191
	ret	z
	ld	a,(23611)
	and	16
	ret	z
	inc	hl
	ret
