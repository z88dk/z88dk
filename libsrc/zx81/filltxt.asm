;
;	ZX81 libraries - Stefano 7/8/2009
;
;----------------------------------------------------------------
;
;	$Id: filltxt.asm,v 1.4 2012-01-09 16:02:36 stefano Exp $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	XLIB   filltxt
	LIB    zx_topleft

	XREF   base_graphics

filltxt:
	; __FASTCALL__ mode
	ld	a,l

	ld	hl,(16396)
	inc	hl

	ld	b,24
floop:
	push	bc
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	inc	hl
	inc	hl
	pop	bc
	djnz 	floop
	jp  zx_topleft
