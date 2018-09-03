;

		SECTION		code_driver

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		generic_console_flags


		INCLUDE		"target/lynx/def/lynx.def"
		INCLUDE		"ioctl.def"

generic_console_set_inverse:
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	7
	ld	(SYSVAR_inkst),a
	ret

generic_console_set_paper:
	call	conio_map_colour
	and	7
	ld	(SYSVAR_paperst),a
	ret

generic_console_cls:
	call	$8e5		;Clear screen (based on colours)
	; Now clear alt screen
	exx
	ld	a,$5
	ld	bc,$ff7f
	out	(c),a
	exx	
	ld	a,$24
	out	($80),a
	ld	hl,$a000
	ld	de,$a001
	ld	bc,8191
	ld	(hl),0
	ldir
	xor	a
	exx
	out	(c),a
	exx
	out	($80),a
	ret

generic_console_scrollup:
	push	de
	push	bc
	; Copy into 256 byte buffer and shuffle it up, painfully...
	pop	bc
	pop	de
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	call	generic_console_xypos		;preserves a
	ex	de,hl		;de = destination
	ld	bc,(generic_console_font32)
	bit	7,a
	jr	z,not_udg
	ld	bc,(generic_console_udg32)
	res	7,a
	inc	b
not_udg:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,bc
	dec	h		;-32 characters
	ex	de,hl		;hl=screen, de = font

        ld      a,(generic_console_flags)
        rlca            ;get bit 7 out
        sbc     a
        ld      c,a     ; c = 0/ c = 255

	ld	b,8
loop:
	ld	a,(de)
	xor	c
	push	bc
	push	de
	push	hl
	push	af		;Save value
	ld	c,0
	call	OUTB
	pop	af
	pop	hl
	push	hl

	; Now write to the alt green page so we know what's on screen (and can use it for
	; vpeek etc)
	ld	de,$a000	;Where alt-green is located
	add	hl,de
	ld	e,a		;Save e
	exx
	ld	a,$5
	ld	bc,$ff7f
	out	(c),a
	exx	
	ld	a,$24
	out	($80),a
	ld	(hl),e
	xor	a
	exx
	out	(c),a
	exx
	out	($80),a


	pop	hl
	ld	bc,32
	add	hl,bc
	pop	de
	pop	bc
	inc	de
	djnz	loop
	ret

generic_console_xypos:
	ld	h,b		;y * 256
	ld	l,0
	ld	b,0
	add	hl,bc		;Add x
	ret
