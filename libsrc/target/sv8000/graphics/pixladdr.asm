;

;-----------  GFX paging  -------------

	SECTION	  code_clib

	PUBLIC	pixeladdress
	EXTERN	pixeladdress_MODE1

	EXTERN	__sv8000_mode

	INCLUDE	"target/sv8000/def/sv8000.def"


; Entry  h = x
;        l = y
; Exit: hl = address	
;	 a = pixel number
; Uses: a, bc, de, hl
	defc	pixeladdress = pixeladdress_MODE1
