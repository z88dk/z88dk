;
;	ZX81 libraries - Stefano 7/8/2009
;
;----------------------------------------------------------------
;
;	$Id: filltxt.asm,v 1.5 2012-12-31 10:38:24 stefano Exp $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	XLIB   filltxt
	LIB    zx_topleft

IF FORzx81
	XREF   base_graphics
ENDIF

filltxt:
	; __FASTCALL__ mode
	ld	a,l
	
	ld	hl,(16396)
	inc	hl			; skip the first 'halt' instruction in the D-FILE

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

IF FORzx80
	push af
	ld	a,118
	ld	(hl),a
	pop af
ENDIF

	inc	hl
	pop	bc
	djnz 	floop

	jp  zx_topleft
