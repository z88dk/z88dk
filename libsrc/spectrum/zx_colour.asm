; 09.2009 stefano

; void __FASTCALL__ zx_colour(uchar colour)

XLIB zx_colour

.zx_colour
   ld 	a,l
		ld	d,l
		ld	e,l
		ld	hl,0
		ld	b,48
		add	hl,sp
		ld	sp,16384+6912
.clrloop
		push	de
		push	de
		push	de
		push	de

		push	de
		push	de
		push	de
		push	de
		djnz	clrloop

		ld	sp,hl
		ret
