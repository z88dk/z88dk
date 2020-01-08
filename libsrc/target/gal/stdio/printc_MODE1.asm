
		; code_driver to ensure we don't page ourselves out
		SECTION		code_clib

		PUBLIC		printc_MODE1



		EXTERN		generic_console_flags
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32


; c = x
; b = y
; d = character
; e = raw
; a = screen port
printc_MODE1:
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
	ld	bc,($2a6a)
	add	hl,bc		;hl = screen
	ld	bc,$20
	add	hl,bc

	ld	a,(generic_console_flags)
	rlca
	sbc	a,a
	ld	c,a		;x = 0 / 255
	ld	b,8
hires_printc_1:
        push    bc
        ld      a,(generic_console_flags)
        bit     4,a
	ld	a,(de)
	ld	b,a
	jr	z,no_32_bold
	rrca
	or	b
no_32_bold:
        cpl			;Pixels are inverse by default
	xor	c
        ; Display is mirrored, so mirror the byte
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
	ld	bc,32
	add	hl,bc
no_overflow:
        pop     bc
	djnz	hires_printc_1
	ld	a,(generic_console_flags)
	bit	3,a
	ret	z
	ld	bc,-32
	add	hl,bc
	ld	(hl),0	;Pixels are inverted
	ret

