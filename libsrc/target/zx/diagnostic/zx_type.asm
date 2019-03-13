;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 22/09/2006
;
;	int zx_type();
;
;	The result is:
;	- 0 (false) if the spectrum is a 48K
;	- 1 (true) if the spectrum is a Spectrum 128K or compatible
;	- 2 (true) if the spectrum is a TS2068
;
;	$Id: zx_type.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_type
	PUBLIC	_zx_type
	
zx_type:
_zx_type:
	ld	hl,0
	ld	a,(75)
	cp	191
	ret	z
	inc	hl
	cp	225
	ret	nz
	inc	hl
	ret
