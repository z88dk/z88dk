;
;
; Aquarius colours
; 0  = black
; 1  = red
; 2  = green
; 3  = yellow
; 4  = blue
; 5  = violet
; 6  = cyan
; 7  = white
; 8  = light grey
; 9  = blue green
; 10 = magenta
; 11 = dark blue
; 12 = light yellow
; 13 = light green
; 14 = orange
; 15 = dark gray


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__aquarius_attr
		EXTERN		conio_map_colour

		defc		DISPLAY = 12328
		defc		COLOUR_MAP = DISPLAY + 1024

		INCLUDE		"ioctl.def"
		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR 

generic_console_ioctl:
	scf
generic_console_set_attribute:
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	15
	rla
	rla
	rla
	rla	
	ld	e,a
	ld	a,(__aquarius_attr)
	and	@00001111
	or	e
	ld	(__aquarius_attr),a
	ret

	
generic_console_set_paper:
	call	conio_map_colour
	and	15
	ld	e,a
	ld	a,(__aquarius_attr)
	and	@11110000
	or	e
	ld	(__aquarius_attr),a
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__aquarius_attr)
	ld	(hl),a
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	(hl),a
	inc	h
	inc	h
	inc	h
	inc	h
	ld	a,(__aquarius_attr)
	ld	(hl),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
        ld      a,(hl)
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
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	hl, COLOUR_MAP + CONSOLE_COLUMNS
	ld	de, COLOUR_MAP
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,(__aquarius_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	bc
	pop	de
	ret

