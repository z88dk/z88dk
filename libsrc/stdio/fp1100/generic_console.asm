

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		__console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		INCLUDE		"target/fp1100/def/fp1100.def"

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_ink:
	and	7
	ld	b,a
	ld	a,(__attr)
	and	@01110000
	or	b
	ld	(__attr),a
set_colour:
	ld	bc,(__attr)
	ld	a,SUB_COLOUR
	call	TRNC3
	ret

generic_console_set_paper:
	rlca
	rlca
	rlca
	rlca
	and	@01110000
	ld	b,a
	ld	a,(__attr)
	and	@00000111
	or	b
	ld	(__attr),a
	jr	set_colour

generic_console_cls:
	ld	a,SUB_CLS
	call	TRNC1
	ret

generic_console_scrollup:
	push	de
	push	bc
	ld	a,SUB_SCROLLUP
	call	TRNC1
	pop	bc
	pop	de
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	push	af
	ld	hl,__lastxy
	ld	a,(hl)
	cp	c
	jr	nz,set_position
	inc	hl
	cp	b
	jr	z,skip_position
set_position:
	ld	(__lastxy),bc
	ld	a,SUB_SETXY
	call	TRNC3
skip_position:
	pop	af
	ld	b,a
	ld	a,SUB_PRINTCHAR
	call	TRNC2
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	scf
	ret


	SECTION		data_clib

__attr:		defb	0x07
		defb	0x00

	SECTION		bss_clib
__lastxy:	defw	-1
