;

;-----------  GFX paging  -------------

	SECTION code_clib
	PUBLIC	pixeladdress_MODE1

        INCLUDE "graphics/grafix.inc"


; Entry  h = x
;        l = y
; Exit: hl = address	
;	 a = pixel number
; Uses: a, bc, de, hl
.pixeladdress_MODE1

	; add y-times the nuber of bytes per line (32)
	; or just multiply y by 32 and the add
	ld	e,h
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	a,e
	srl	e
	srl	e
	srl	e
	ld	d,0
	add	hl,de
	and	7
	xor	7
	ret
