
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		printc_MODE1

		EXTERN		__mc1000_modeval


		EXTERN		generic_console_flags
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32

		defc		DISPLAY = 0x8000

; c = x
; b = y
; d = character
; e = raw
; a = screen port
printc_MODE1:
	ld	a,(__mc1000_modeval)
	ex	af,af		;save port
	ld	l,d
	ld	h,0
	ld	de,(generic_console_font32)
	bit	7,l
	jr	z,not_udg
	res	7,l		;take off 128
	ld	de,(generic_console_udg32)
	inc	d		;We decrement later
not_udg:
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	h		; -32 characters
	ex	de,hl		; de = font
	ld	h,b		; 32 * 8
	ld	l,c
	ld	bc,DISPLAY
	add	hl,bc		;hl = screen

	ld	a,(generic_console_flags)
	rlca
	sbc	a,a
	ld	c,a		;x = 0 / 255
	ld	b,8
hires_printc_1:
	push	bc
	ld	a,(de)
	xor	c
	ld	c,a
	ex	af,af
	res	0,a
	out	($80),a		;VRAM -> Z80
	ld	(hl),c
	set	0,a
	out	($80),a		;VRAM -> Chip
	ex	af,af
	inc	de
	ld	a,l
	add	32
	ld	l,a
	jr	nc,no_overflow
	inc	h
no_overflow:
	pop	bc
	djnz	hires_printc_1
	ret

