;
;


		SECTION		code_clib

		PUBLIC		printc_MODE1

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		generic_console_flags

printc_MODE1:
	ld	l,d
	ld	h,0
	ld	de,(generic_console_font32)
	bit	7,l
	jr	z,not_udg
	res	7,l
	ld	de,(generic_console_udg32)
	inc	d	
not_udg:
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	h
	ex	de,hl		;de = font
	; bc is already set 

	; Set up the inverse state
	ld	a,(generic_console_flags)
	rlca
	sbc	a,a		; So 0 / 255
	ld	h,a

	ld	l,8
hires_printc_1:
	ld	a,(de)
	xor	h
	out	(c),a
	ld	a,c
	add	32
	ld	c,a
	jr	nc,no_overflow
	inc	b
no_overflow:
	inc	de
	dec	l
	jr	nz,hires_printc_1
	ret


