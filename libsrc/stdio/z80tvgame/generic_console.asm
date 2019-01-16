;
;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		PUBLIC		generic_console_xypos_graphics

		EXTERN		generic_console_flags
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32


		EXTERN		CRT_FONT
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = $c03c + 4

generic_console_set_ink:
generic_console_set_paper:
generic_console_set_inverse:
	ret

generic_console_cls:
	ld	hl,$c000
	ld	de,$c001
	ld	bc,8191
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
	ld	a,(generic_console_flags)
	rlca
	sbc	a
	ld	c,a		;c = 0/c = 255 = inverse
	ld	b,8
loop:
	push	bc
	ld	a,(de)
	xor	c
        ld      c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
        rrc     c
        xor     c
        and     0x66
        xor     c
	ld	(hl),a
	inc	de
	ld	bc,30
	add	hl,bc
	pop	bc	
	djnz	loop
	ret


; Calculate the address for the graphics mode
generic_console_xypos_graphics:
	ld	hl, DISPLAY - 30 * 8
	ld	de, 30 * 8
	inc	b
generic_console_xypos_graphics_1:
	add	hl,de
	djnz	generic_console_xypos_graphics_1
	add	hl,bc
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	de,DISPLAY
	ld	hl,DISPLAY + 30 * 8
	ld	bc, CONSOLE_ROWS * 30 * 8
	ldir
	ex	de,hl
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,30 * 8 - 1
	ld	(hl),0
	ldir
	pop	bc
	pop	de
	ret
