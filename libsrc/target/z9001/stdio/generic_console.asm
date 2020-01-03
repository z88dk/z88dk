;
;

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
		EXTERN		__z9001_attr
		EXTERN		conio_map_colour
		EXTERN		generic_console_flags

		defc		DISPLAY = 0xEC00
		defc		COLOUR_MAP = DISPLAY - 1024 

		EXTERN		ansi_cls
		EXTERN		ansi_SCROLLUP

		defc		generic_console_cls = ansi_cls
		defc		generic_console_scrollup = ansi_SCROLLUP

		INCLUDE		"ioctl.def"
		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = CAP_GENCON_FG_COLOUR | CAP_GENCON_BG_COLOUR | CAP_GENCON_INVERSE


generic_console_ioctl:
	scf
generic_console_set_attribute:
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	7
	rla
	rla
	rla
	rla	
	ld	e,a
	ld	a,(__z9001_attr)
	and	@00001111
	or	e
	ld	(__z9001_attr),a
	ret

	
generic_console_set_paper:
	call	conio_map_colour
	and	7
	ld	e,a
	ld	a,(__z9001_attr)
	and	@11110000
	or	e
	ld	(__z9001_attr),a
	ret



; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	(hl),a
	dec	h
	dec	h
	dec	h
	dec	h
	ld	a,(generic_console_flags)
	rlca
	ld	a,(__z9001_attr)
	jr	nc,not_inverse
	rlca
	rlca
	rlca
	rlca
not_inverse:
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

