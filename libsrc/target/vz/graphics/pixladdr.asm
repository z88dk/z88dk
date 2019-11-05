;

;-----------  GFX paging  -------------

	SECTION	  code_clib

	PUBLIC	pixeladdress
	EXTERN	pixeladdress_MODE1


; Entry  h = x
;        l = y
; Exit: de = address	
;	hl = undisturbed
;	 a = pixel number
; Uses: a, bc, de, hl
	defc pixeladdress = pixeladdress_MODE1
