

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		generic_console_pointxy
		PUBLIC		generic_console_plotc

		EXTERN		mc6847_map_colour
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x7000

generic_console_ioctl:
	scf
generic_console_set_paper:
generic_console_set_inverse:
	ret

generic_console_set_ink:
	call	mc6847_map_colour
	ld	a,b
	rlca
	rlca
	rlca
	rlca
	or	128
	and	@11110000
	ld	(colour_mask),a
	ret

	

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_plotc:
	inc	e
generic_console_printc:
	push	de
	call	xypos
	pop	de
	rr	e
	call	nc,convert_character
	cp	128
	jr	c,place_character
	and	@10001111
	ld	c,a
	ld	a,(colour_mask)
	or	c
place_character:
	ld	(hl),a
	ret


generic_console_pointxy:
	call	generic_console_vpeek
	and	@10001111
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	a
	ret


xypos:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret

convert_character:
        cp      97
        jr      c,isupper
        sub     32
.isupper
        and     @00111111
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + CONSOLE_COLUMNS
	ld	de, DISPLAY
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret

	SECTION	bss_clib

colour_mask:	defb	0
