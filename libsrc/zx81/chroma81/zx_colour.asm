; 12.2014 stefano

; void __FASTCALL__ zx_colour(uchar colour)

XLIB zx_colour
XREF HRG_LineStart

.zx_colour
		ld 	a,l
		ld	hl,HRG_LineStart+2+32768

		ld	c,24
.rowloop
		ld	b,32
.rowattr
		ld	(hl),a
		inc hl
		djnz rowattr
		inc	hl
		inc	hl
		inc	hl
		dec c
		jr  nz,rowloop
		ret
