;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_kempstonmouse();
;
;	The result is:
;	- 1 (true) if a Kempston mouse is present
;	- 0 (false) otherwise
;
;	$Id: zx_kempstonmouse.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_kempstonmouse
	PUBLIC	_zx_kempstonmouse
	
zx_kempstonmouse:
_zx_kempstonmouse:
	ld	hl,0
	ld	de,65535
loop:
	ld	bc,64223
	in	a,(c)
	cp	255
	ret	nz
	dec	de
	ld	a,d
	or	e
	jr	nz,loop
	
	inc	hl
	ret
