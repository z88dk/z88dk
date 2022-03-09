

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_text_xypos


		EXTERN		printc_MODE1
		EXTERN		scrollup_MODE1

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__gal_mode

		defc		DISPLAY = 0x2800

generic_console_set_paper:
generic_console_set_attribute:
generic_console_set_ink:
	ret

	

generic_console_cls:
	ld	a,(__gal_mode)
        and     a
        jr      z,cls_mode0
	ld	hl, ($2a6a)
	ld	de,$20
	add	hl,de
	ld	d,h	
	ld	e,l
	inc	de
	ld	bc, +(32 * 208) - 1
	ld	(hl),0xff
	ldir
	ret
cls_mode0:
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
generic_console_printc:
	ld	d,a
	ld	a,(__gal_mode)
	cp	1
	jp	z,printc_MODE1
	push	de
	call	generic_console_text_xypos
	pop	de
	ld	a,d
	rr	e
	call	nc,convert_character
	ld	(hl),a
	ret


generic_console_text_xypos:
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
	ld	a,(__gal_mode)
	cp	1
	jp	z,scrollup_MODE1
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
