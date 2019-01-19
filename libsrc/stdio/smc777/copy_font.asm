

        SECTION code_clib

        PUBLIC  copy_font_8x8


; Copy font in PCG area
; Entry: e = number of characters
;       hl = address to copy from
;       bc = address for PCG (needs swapping)
copy_font_8x8:
	ld	a,c
	ld	c,b
	ld	b,a
loop_1:
	ld	d,8
loop_2:
	push	de
	ld	a,(hl)
	out	(c),a
	inc	hl
	inc	b
	jr	nz,skip_1
	inc	c
skip_1:
	pop	de
	dec	d
	jr	nz,loop_2
	dec	e
	jr	nz,loop_1
	ret
	



