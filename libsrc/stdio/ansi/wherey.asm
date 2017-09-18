; void wherey()
; 09.2017 stefano

SECTION code_clib
PUBLIC wherey
PUBLIC _wherey

EXTERN ansi_COLUMN

.wherey
._wherey

	ld	a,(ansi_COLUMN)
	ld	l,a
	ld	h,0
	ret
