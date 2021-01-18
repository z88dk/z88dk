
	SECTION	code_clib
	PUBLIC	w_pixeladdress

	EXTERN	w_pixeladdress_MODE0
	EXTERN	pixeladdress_MODE6
	EXTERN	__zx_screenmode



; Entry  hl = x
;        de = y
; Exit: hl = de = address
;        a = pixel number
; Uses: a, bc, de, hl

w_pixeladdress:
        ld      a,(__zx_screenmode)
        cp      3
        jp      c,w_pixeladdress_MODE0
        jp      pixeladdress_MODE6

