
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
;	  fz	= 1 if bit number is 0 of pixel position
;

.pixeladdress
	ld	a,h	;Save x
	ld	h,0
	add	hl,hl	;*32
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	e,a
	srl	e
	srl	e
	srl	e
	ld	d,$c0		;Screen address
	add	hl,de
	ex	de,hl
	and	7
	ret
