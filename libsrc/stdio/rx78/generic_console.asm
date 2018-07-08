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
	ld	(__rx78_ink),a
	ret

	
generic_console_set_paper:
	and	7
	ld	(__rx78_paper),a
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
	ld	bc,(__rx78_ink)
	ld	a,c
	cpl
	and	@00000111
	ld	b,a
	ld	a,8
loop:	push	af
	push	bc
	ld	a,(de)
	ld	c,a		;Mirror the font
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

	pop	bc		;Pages back now

	ex	af,af		;Save byte for a bit
	ld	a,c		;ink set
	out	($f2),a
	ex	af,af
	ld	(hl),a
	ld	a,b		;Unset pages
	out	($f2),a
	ex	af,af
;	ld	(hl),0

	ld	a,l
	add	24
	ld	l,a
	jr	nc,noinc
	inc	h
noinc:
	inc	de
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

__rx78_ink:	  defb	0x07
__rx78_paper:	  defb	0x01



	SECTION		code_crt_init

	ld	hl, initial_palette
	ld	b, 7
pal_loop:
	ld	a,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	out	(c),a
	djnz	pal_loop

	SECTION		rodata_clib
initial_palette:
	defb	0x11, 0xf5
	defb	0x22, 0xf6
	defb	0x44, 0xf7
	defb	0x11, 0xf8
	defb	0x22, 0xf9
	defb	0x44, 0xfa
	defb	0xff, 0xfb
