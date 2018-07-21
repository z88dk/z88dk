;

;-----------  GFX paging  -------------

	SECTION	  code_clib

	PUBLIC	pixeladdress
	EXTERN	pixeladdress_MODE1

	EXTERN	__pc6001_mode

	INCLUDE	"target/pc6001/def/pc6001.def"


; Entry  h = x
;        l = y
; Exit: hl = address	
;	 a = pixel number
; Uses: a, bc, de, hl
.pixeladdress
	ld	a,(__pc6001_mode)
	cp	MODE_1
	jp	z,pixeladdress_MODE1
	ret
