
	SECTION	code_clib
	PUBLIC	pixeladdress

	INCLUDE	"graphics/grafix.inc"


; Entry  h = x
;        l = y
; Exit: hl = address
;        a = pixel number
;       Fz = pixel 0 in byte
; Uses: a, de, hl
.pixeladdress
	ld	d,h	;Save x
	ld	h,0
	add	hl,hl	;*64
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	a,d	;4 pixels per byte
	rrca
	rrca
	and	63
	ld	e,a
	ld	a,d
	ld	d,$40	;Screenbase
	add	hl,de
	and	3
	ret
