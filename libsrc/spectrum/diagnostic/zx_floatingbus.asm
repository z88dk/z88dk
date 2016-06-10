;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 12/02/2008
;
;	int zx_floatingbus();
;
;	The result is:
;	- 1 (true) if Spectrum has floating bus
;	- 0 (false) otherwise
;
;	$Id: zx_floatingbus.asm,v 1.3 2016-06-10 20:02:05 dom Exp $
;

	SECTION code_clib
	PUBLIC	zx_floatingbus
	PUBLIC	_zx_floatingbus
	
zx_floatingbus:
_zx_floatingbus:
	ld	hl,1
	ld	e,h
	ld	bc,32767
loop:
	push	bc
	ld	bc,65535
	in	a,($c)
	pop	bc
	add	e
	ld	e,a
	dec	bc
	ld	a,b
	or	c
	jr	nz,loop
	
	ld	a,e
	cp	l	; is it one ?
	ret	nz	; no, floating bus is present !

	dec	hl
	ret
