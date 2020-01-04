

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_set_ink
		PUBLIC		generic_console_set_paper
		PUBLIC		generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CRT_FONT

		defc            DISPLAY = 0x2400
	        defc		CHAR_TABLE = 0x2C00


generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc,767
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
	jr	c,is_raw
	; In non-raw mode characters > 128 are udgs
	res	7,a
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


; If compiled with a font option then set it up
        SECTION code_crt_init

        ld      hl,CRT_FONT
        ld      a,h
        or      l
        jr      z,no_set_font
        ld      de,CHAR_TABLE + 256
        ld      bc,768
        ldir
no_set_font:
