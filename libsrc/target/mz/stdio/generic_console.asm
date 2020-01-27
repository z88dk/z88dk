;
; Sharp colours
;
; 0 = black
; 1 = blue
; 2 = red
; 3 = purple
; 4 = green
; 5 = light blue
; 6 = yellow
; 7 = white


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		sharpmz_from_ascii
		EXTERN		sharpmz_to_ascii
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0xd000
		defc		COLOUR_MAP = 0xd800

		INCLUDE		"ioctl.def"
		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS =  CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR

generic_console_ioctl:
	scf
	ret

; For the Sharp we use inverse to switch to the alternate character set
generic_console_set_attribute:
	ld	b,(hl)		;flags 2 - we want bit 7
	ld	a,(__sharpmz_attr)
	rla			;dump existing extend flag
	rr	b		;get new flag
	rra
	ld	(__sharpmz_attr),a
	ret

generic_console_set_ink:
	and	7
	rla
	rla
	rla
	rla	
	ld	e,a
	ld	a,(__sharpmz_attr)
	and	@10000111
	or	e
	ld	(__sharpmz_attr),a
	ret

	
generic_console_set_paper:
	and	7
	ld	e,a
	ld	a,(__sharpmz_attr)
	and	@11110000
	or	e
	ld	(__sharpmz_attr),a
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),0
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__sharpmz_attr)
	ld	(hl),a
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	rr	e
	call	nc,sharpmz_from_ascii		;exits with a = character
	call	xypos
	ld	(hl),a
	ld	a,h
	add	8
	ld	h,a
	ld	a,(__sharpmz_attr)
	ld	(hl),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	push	de
        call    xypos
        ld      a,(hl)
	pop	de
	rr	e
	call	nc, sharpmz_to_ascii
        and     a
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
	ld	(hl),0
	inc	hl
	djnz	generic_console_scrollup_3
	ld	hl, COLOUR_MAP + CONSOLE_COLUMNS
	ld	de, COLOUR_MAP
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,(__sharpmz_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	bc
	pop	de
	ret


	SECTION	data_clib

.__sharpmz_attr	defb $70        ; White on Black
