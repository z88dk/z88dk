

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper

		EXTERN		__console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

generic_console_ioctl:
	scf
	ret

generic_console_set_ink:
	ld	hl,text_colour
	and	15
	ld	b,a
	ld	a,(hl)
	and	@11110000
	or	b
	ld	(hl),a
	ret

generic_console_set_paper:
	ld	hl,text_colour
	rlca
	rlca
	rlca	
	rlca
	and	@11110000
	ld	b,a
	ld	a,(hl)
	and	15
	or	b
	ld	(hl),a
	ret

generic_console_cls:
	ld	de,0
	ld	hl,(__console_w)	; +(CONSOLE_ROWS * 256 ) + CONSOLE_COLUMNS
	ld	a,(text_colour)
	ld	b,a
	ld	a,' '
	ld	c,0x56		;CLEAR
	rst	$10
	ret

generic_console_scrollup:
	push	de
	push	bc
	ld	de,0
	ld	hl,(__console_w)	; +(CONSOLE_ROWS * 256 ) + CONSOLE_COLUMNS
	ld	b,1
	ld	a,0
	ld	c,0x55		;SCROLL
	rst	$10
	pop	bc
	pop	de
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	rl	e
	jr	c,generic_console_printc_1
	; Here we can interpret any extra codes (eg for setting colours)

generic_console_printc_1:
	ld	d,b
	ld	e,c
	ex	af,af
	ld	a,(text_colour)
	ld	b,a
	ex	af,af
	ld	c,0x58		;WRCHAR
	rst	$10
	ret

		SECTION		data_clib

text_colour:	defb	@00001111	;bright white on black

