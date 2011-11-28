;
;	ZX81 libraries - Stefano 7/8/2009
;
;--------------------------------------------------------------
;
;	$Id: filltxt.asm,v 1.2 2011-11-28 20:14:50 stefano Exp $
;
;----------------------------------------------------------------
;
; Fill text memory with specified character code
;
;----------------------------------------------------------------

	XLIB	filltxt

	XREF	base_graphics

	DEFC	COLUMN=$4039    ; S_POSN_x

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

	ld  hl,$1821	; (33,24) = top left screen posn
	ld  (COLUMN),hl
	ld	hl,(16396)	; D_FILE
    ld  ($400E),hl	; DF_CC ..position ZX81 cursor at beginning of display file
	ret
