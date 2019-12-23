

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		__console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__sprinter_attr

		INCLUDE		"ioctl.def"
		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR

generic_console_ioctl:
	scf
generic_console_set_attribute:
	ret

generic_console_set_ink:
	ld	hl,__sprinter_attr
	and	15
	ld	b,a
	ld	a,(hl)
	and	@11110000
	or	b
	ld	(hl),a
	ret

generic_console_set_paper:
	ld	hl,__sprinter_attr
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
	ld	a,(__sprinter_attr)
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
	ld	d,b
	ld	e,c
	ex	af,af
	ld	a,(__sprinter_attr)
	ld	b,a
	ex	af,af
	ld	c,0x58		;WRCHAR
	rst	$10
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	d,b
	ld	e,c
	ld	c,0x57		;RDCHAR
	rst	$10
	and	a
	ret


