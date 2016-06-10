; 09.2009 stefano

; void __FASTCALL__ zx_colour(uchar colour)

SECTION code_clib
PUBLIC zx_colour
PUBLIC _zx_colour

.zx_colour
._zx_colour
        ld a,i
        push af
        di

		ld 	a,l
        ;ld  (23624),a
		ld  (23693),a

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
        pop af
        ret po
        ei
        ret
