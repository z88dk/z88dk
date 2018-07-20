
		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		PUBLIC		__pc6001_attr

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		; PC6001 - DISPLAY = $8200, COLOUR = $8000
		; PC6001mk2 - DISPLAY = $c200, COLOUR = $c000

		INCLUDE		"target/pc6001/def/pc6001.def"

generic_console_ioctl:
	scf
	ret

generic_console_set_inverse:
	ld	a,(hl)
	ld	c,0
	rlca
	rl	c
	ld	a,(__pc6001_attr)
	and	254
	or	c
	ld	(__pc6001_attr),a
	ret

generic_console_set_ink:
	and	2
	ld	e,a
	ld	a,(__pc6001_attr)
	and	@11111101
	or	e
	ld	(__pc6001_attr),a
	ret

	
generic_console_set_paper:
	and	15
	ld	e,a
	ld	a,(__pc6001_attr)
	and	@11110000
	or	e
	;ld	(__pc6001_attr),a
	ret

generic_console_cls:
	ld	hl,(SYSVAR_screen - 1)
	inc	h
	inc	h
	ld	l,0
	ld	d,h
	ld	e,1
	push	hl
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	pop	hl
	dec	h
	dec	h
	ld	d,h
	ld	e,1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__pc6001_attr)
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
	dec	h
	dec	h
	ld	a,(__pc6001_attr)
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
	push	af
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	a,(SYSVAR_screen)
	inc	a
	inc	a
	ld	b,a
	add	hl,bc
	pop	af
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl,(SYSVAR_screen - 1)
	inc	h
	inc	h
	ld	l, CONSOLE_COLUMNS
	ld	d,h
	ld	e,0
	push	hl	; Save start of screen
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	hl		;Get screen back
	dec	h
	dec	h
	ld	d,h
	ld	e,0
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,(__pc6001_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4


	pop	bc
	pop	de
	ret


	SECTION data_clib

__pc6001_attr:	defb	32		;We use the external character generator
