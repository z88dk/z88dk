;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		conio_map_colour
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__alphatro_attr
		EXTERN		__console_w

		defc		DISPLAY = 0xf000
		defc		COLOUR_MAP = 0xf800
	

generic_console_set_attribute:
	ld	a,(__alphatro_attr)
	res	7,a
	bit	7,(hl)	
	jr	z,no_inverse
	set	7,a
no_inverse:
	ld	(__alphatro_attr),a
	ret


generic_console_set_paper:
	call	conio_map_colour
	and	7
	ld	b,a
	ld	a,(__alphatro_attr)
	and	@11111000
	or	b
	ld	(__alphatro_attr),a
	ret
	
generic_console_set_ink:
	call	conio_map_colour
	rlca
	rlca
	rlca
	and	@00111000
	ld	b,a
	ld	a,(__alphatro_attr)
	and	@11000111
	or	b
	ld	(__alphatro_attr),a
	ret
	

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, 80 * 24 - 1
	ld	(hl),32
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, 80 * 24 - 1
	ld	(hl),32
	ld	a,(__alphatro_attr)
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
	ld	a,h
	add	8
	ld	h,a
	ld	a,(__alphatro_attr)
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
	ld	hl,DISPLAY
	ld	de,(__console_w)
	ld	d,0
	and	a
	sbc	hl,de
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
	ld	hl, DISPLAY + 40
	ld	de, DISPLAY
	ld	bc,+ (40 * 23)
	ld	a,(__console_w)
	cp	40
	jr	z,got_size
	ld	hl, DISPLAY + 80
	ld	bc, + (80 * 23)
got_size:
	ldir
	ex	de,hl
	ld	a,(__console_w)
	ld	b,a
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	hl, COLOUR_MAP + 40
	ld	de, COLOUR_MAP
	ld	bc,+ (40 * 23)
	ld	a,(__console_w)
	cp	40
	jr	z,got_size_2
	ld	hl, COLOUR_MAP + 80
	ld	bc, + (80 * 23)
got_size_2:
	ldir
	ex	de,hl
	ld	a,(__console_w)
	ld	b,a
	ld	a,(__alphatro_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	bc
	pop	de
	ret

	SECTION		code_crt_init

	EXTERN		asm_set_cursor_state
	ld	l,0x20		;disable cursor
	call	asm_set_cursor_state

