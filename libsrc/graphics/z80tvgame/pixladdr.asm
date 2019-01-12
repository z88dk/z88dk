
	SECTION	code_clib
	PUBLIC	pixeladdress

	INCLUDE	"graphics/grafix.inc"

	EXTERN	base_graphics

;
;	$Id: pixladdr.asm,v 1.9 2016-04-22 20:17:17 dom Exp $
;

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed

.pixeladdress
	; The screen is 30 characters per row
	ld	e,h
	ld	c,l
	ld	b,0
	ld	h,0
	add	hl,hl	;*2
	add	hl,hl
	add	hl,hl	;*8
	add	hl,hl	;*16
	and	a
	sbc	hl,bc	;*15
	add	hl,hl	;*30
	ld	a,e
	srl	e
	srl	e
	srl	e
	ld	d,0
	add	hl,de
	ld	de,$c03c+4	;Where the screen starts
	add	hl,de
	ex	de,hl
	and	7
	ret


	

