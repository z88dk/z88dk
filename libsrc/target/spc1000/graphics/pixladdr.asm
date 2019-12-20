;

;-----------  GFX paging  -------------

	SECTION	  code_clib

	PUBLIC	pixeladdress
	EXTERN	pixeladdress_MODE1
	EXTERN	pixeladdress_MODE2

	EXTERN	__spc1000_mode

	INCLUDE	"target/spc1000/def/spc1000.def"


; Entry  h = x
;        l = y
; Exit: hl = address	
;	 a = pixel number
; Uses: a, bc, de, hl
.pixeladdress
	ld	a,(__spc1000_mode)
	cp	1
	jp	z,pixeladdress_MODE1
	cp	2
	jp	z,pixeladdress_MODE2
	ret
