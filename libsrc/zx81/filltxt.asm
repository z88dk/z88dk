;
;	ZX81 libraries - Stefano 7/8/2009
;
;----------------------------------------------------------------
;
;	$Id: filltxt.asm,v 1.6 2014-07-18 06:18:09 stefano Exp $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	XLIB   filltxt
	LIB    zx_topleft

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
