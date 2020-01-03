

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_set_ink
		PUBLIC		generic_console_set_paper
		PUBLIC		generic_console_set_attribute

		PUBLIC		__exidy_custom_font

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CRT_FONT

		defc		DISPLAY = 0xf080
	        defc		CHAR_TABLE = 0xfc00


generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc,+(64 * 30) - 1
	ld	(hl),32
	ldir
	ret

generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	push	de
	call	xypos
	pop	de
	rr	e
	jr	c,is_raw	;Just pass it through
	ld	d,a		;save character
	ld	a,(__exidy_custom_font)
	and	a
	ld	a,d
	jr	z,is_raw	;just pass it through
	; If we have a custom font then we need to use chars 160 - 255 for font
	; And chars 128 - 159 = udgs
	set	7,a
is_raw:
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	a,(__exidy_custom_font)
	and	a
	ld	a,(hl)
	call	nz,has_custom_font
vpeek_return:
	and	a
	ret

has_custom_font:
	cp	160
	ret	c		; It's < 160, ignore it
	res	7,a		; It's the custom font, clear bit 7 so its now ascii
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

__exidy_custom_font:	defb	0

	SECTION	code_crt_init

	ld	hl,CRT_FONT
	ld	a,h
	or	l
	jr	z,no_set_font
	ld	(__exidy_custom_font),a
	ld	de,CHAR_TABLE + 256
	ld	bc,768
	ldir
no_set_font:

