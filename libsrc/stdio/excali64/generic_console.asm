;
;

		SECTION		code_graphics

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__excali64_attr

		defc		DISPLAY = $2000
		defc		COLOUR_MAP = $2800

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_ink:
	and	15
	rla
	rla
	rla
	rla	
	ld	e,a
	ld	a,(__excali64_attr)
	and	@00001111
	or	e
	ld	(__excali64_attr),a
	ret

	
generic_console_set_paper:
	and	7
	rrca
	ld	e,a
	ld	a,(__excali64_attr)
	and	@11110001
	or	e
	ld	(__excali64_attr),a
	ret

generic_console_cls:
	in	a,($50)
	push	af
	res	1,a
	set	0,a
	out	($70),a
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__excali64_attr)
	ld	(hl),a
	ldir
	pop	af
	out	($70),a
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	d,a
	in	a,($50)
	push	af
	res	1,a
	set	0,a
	out	($70),a
	ld	(hl),d
	ld	a,h
	add	8
	ld	h,a
	ld	a,(__excali64_attr)
	ld	(hl),a
	pop	af
	out	($70),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	in	a,($50)
	push	af
	res	1,a
	set	0,a
	out	($70),a
        ld      d,(hl)
	pop	af
	out	($70),a
	ld	a,d
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
	in	a,($50)
	push	af
	res	1,a
	set	0,a
	out	($70),a
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
	ld	a,(__excali64_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	af
	out	($70),a
	pop	bc
	pop	de
	ret

