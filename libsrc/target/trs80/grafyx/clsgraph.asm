;
;       Micro-Labs Grafyx Solution Hi-Rez graphics routines for TRS-80
;
;       Stefano Bodrato 2021
;

	SECTION	  code_clib
	PUBLIC    clsgraph
	PUBLIC    _clsgraph
	PUBLIC    clg
	PUBLIC    _clg

	INCLUDE	"graphics/grafix.inc"


.clsgraph
._clsgraph
.clg
._clg
	ld	a,255
	out (131),a   ; enable graphics page
	
	ld	hl,maxx
	srl     h     ;hl = x / 8
	rr      l
	srl     h
	rr      l
	srl     h
	rr      l

	ld	bc,128
	xor a

.clsloop
	ld	e,maxy
.clsloop2
	
	inc bc
	out (c),e	; set Y coord
	dec bc
	out (c),l	; set X coord

	;ld	a,l		; test pattern
	;add e
	out (130),a	; write 0 (or pattern) to display

	dec e
	jr nz,clsloop2
	dec l
	jr nz,clsloop

	ret
