; Print a character on display

	XLIB fputc_lcd

.dispchr
	ld	hl,2
	add	hl,sp
	ld	e,(hl)	; char
	inc	hl
	inc	hl
	ld	a,77
	sub	(hl)	; pos 0..15
	ld	l,a
	ld	h,0
	ld	a,e
	ld	(hl),a
	ret
