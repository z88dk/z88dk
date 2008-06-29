;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_soundchip();
;
;	The result is:
;	- 1 (true) if a sound chip is present
;	- 0 (false) otherwise
;
;	$Id: zx_soundchip.asm,v 1.1 2008-06-29 08:25:47 aralbrec Exp $
;

	XLIB	zx_soundchip
	
zx_soundchip:
	ld	hl,0
	ld	bc,$fffd
	ld	a,11		; envelope register
	out	(c),a

	in	a,(c)
	ld	e,a

	xor	170
	ld	b,$bf
	out	(c),a
	ld	b,$ff
	ld	d,a
	in	a,(c)
	cp	d

	ld	b,$bf
	ld	a,e
	out	(c),a		; restore original value
	ret	nz

	inc	hl
	ret
