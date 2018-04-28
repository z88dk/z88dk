; void wherex()
; 09.2017 stefano

SECTION code_clib
PUBLIC wherex
PUBLIC _wherex

EXTERN __console_x

.wherex
._wherex

	ld	a,(__console_x)
	ld	l,a
	ld	h,0
	ret
