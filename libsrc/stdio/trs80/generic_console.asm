

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		__eg2000_custom_font

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		EG2000_ENABLED
		EXTERN		CRT_FONT
		
		EXTERN		base_graphics

		defc		COLOUR_MAP = 0xF000
		defc		CHAR_TABLE = 0xF400
		defc		EG2000_COLOUR_OFFSET = (COLOUR_MAP - 0x4400) /256


generic_console_set_ink:
	and	15
	ld	(__eg2000_attr),a
	ret

generic_console_set_paper:
generic_console_set_inverse:
	ret

generic_console_cls:
	ld	hl, (base_graphics)
	ld	d,l
	ld	e,l
	inc de
	ld	bc,1023
	ld	(hl),32
	ldir
	ld	a,EG2000_ENABLED
	and	a
	ret	z
	ld	hl,COLOUR_MAP
	ld	de,COLOUR_MAP+1
	ld	bc,1023
	ld	a,(__eg2000_attr)
	ld	(hl),a
	ldir
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
	ld	d,a
	ld	a,(__eg2000_custom_font)
	and	EG2000_ENABLED
	ld	a,d
	jr	z,is_raw
	set	7,a	;custom font define, use chars 160-255 for font, 128-159=udgs
is_raw:
	ld	(hl),a
	ld	a,EG2000_ENABLED
	and	a
	ret	z
	ld	a,h
	add	EG2000_COLOUR_OFFSET
	ld	h,a
	ld	a,(__eg2000_attr)
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
        ld      a,(__eg2000_custom_font)
        and     EG2000_ENABLED
	ld	a,(hl)
	call	nz,has_custom_font
	and	a
	ret

has_custom_font:
	cp	160
	ret	c
	res	7,a
	ret

xypos:
	ld	hl, (base_graphics)
	ld	de,CONSOLE_COLUMNS
	inc	b
	sbc hl,de
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, CONSOLE_COLUMNS
	ld	de, (base_graphics)
	add	hl,de
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	a,EG2000_ENABLED
	and	a
	jr	z,scrollup_return
	ld	hl,COLOUR_MAP + CONSOLE_COLUMNS
	ld	de,COLOUR_MAP
        ld      bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
        ldir
        ex      de,hl
        ld      b,CONSOLE_COLUMNS
	ld	a,(__eg2000_attr)
generic_console_scrollup_4:
        ld      (hl),a
        inc     hl
        djnz    generic_console_scrollup_4
scrollup_return:
	pop	bc
	pop	de
	ret


	SECTION		data_clib

__eg2000_attr:	defb	0
__eg2000_custom_font:	defb	0

	SECTION		code_crt_init

	ld	hl,CRT_FONT
	ld	a,h
	or	l
	jr	z,no_set_font
	ld	a,EG2000_ENABLED
	and	a
	jr	z,no_set_font
	ld	(__eg2000_custom_font),a
	ld	de,CHAR_TABLE+256
	ld	bc,768
	ldir
no_set_font:
