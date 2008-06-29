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
;	$Id: zx_kempstonmouse.asm,v 1.1 2008-06-29 08:25:47 aralbrec Exp $
;

	XLIB	zx_kempstonmouse
	
zx_kempstonmouse:
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
