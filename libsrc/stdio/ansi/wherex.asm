; void wherex()
; 09.2017 stefano

SECTION code_clib
PUBLIC wherex
PUBLIC _wherex

EXTERN ansi_COLUMN

.wherex
._wherex

	ld	a,(ansi_COLUMN)
	ld	l,a
	ld	h,0
	ret
