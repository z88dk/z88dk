;

		; In code_driver so we are low down in memory and hopefully
		; never paged out
		SECTION		code_driver

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		PUBLIC		generic_console_xypos_graphics

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32

		EXTERN		CRT_FONT
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0xEEC0


generic_console_set_ink:
	and	7
	ld	b,a
	ld	a,(__rx78_attr)
	and	248
	or	b
	ld	(__rx78_attr),a
	ret

	
generic_console_set_paper:
	ret

generic_console_set_inverse:
	ret

generic_console_cls:
	ld	a,@00111111
	out	($f2),a
	ld	hl, DISPLAY
	ld	de, DISPLAY+1
	ld	bc, +(CONSOLE_ROWS * CONSOLE_COLUMNS * 8) -1
	ld	(hl),0
	ldir
	ret



; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	call	generic_console_xypos_graphics
	ex	de,hl		;de = destination
	ld	bc,(generic_console_font32)
	ld	l,a
	ld	h,0
	bit	7,l
	jr	z,not_udg
	res	7,l
	ld	bc,(generic_console_udg32)
	inc	b
not_udg:
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,bc
	dec	h		;-32 characters
	ex	de,hl		;hl = screen, de = font
	ld	a,@00000111
	out	($f2),a
	ld	a,8
loop:	push	af
	ld	a,(de)
; Let's mirror - painful
	ld	c,a
	rlca
	rlca
	xor	c
	and	0xaa
	xor	c
	ld	c,a
	rlca
	rlca
	rlca
	rrc	c
	xor	c
	and	0x66
	xor	c

	ld	(hl),a
	inc	de

	ld	bc,24
	add	hl,bc

	pop	af
	dec	a
	jr	nz,loop
	ret


; Calculate the address for the graphics mode
generic_console_xypos_graphics:
	ld	hl, DISPLAY - 192
	ld	de, 192
	inc	b
generic_console_xypos_graphics_1:
	add	hl,de
	djnz	generic_console_xypos_graphics_1
	add	hl,bc
	ret


generic_console_scrollup:
	ret



	SECTION		data_clib

__rx78_attr:	  defb	0x07		;white ink


