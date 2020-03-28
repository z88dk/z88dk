;
; SV-8000 supports 16x32 screen + 256x192?


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__sv8000_mode
		EXTERN		printc_MODE1
		EXTERN		generic_console_text_xypos

		INCLUDE         "target/sv8000/def/sv8000.def"

generic_console_set_ink:
generic_console_set_attribute:
generic_console_set_paper:
	ret


generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	a,(__sv8000_mode)
	and	a
	jr	z,cls_text
	ld	bc,3071
	ld	(hl),0
	ldir
	ret
cls_text:
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ex	af,af
	ld	a,(__sv8000_mode)
	cp	MODE_1
	jp	z,printc_MODE1
	and	a
	ret	nz
	ex	af,af
	call	generic_console_text_xypos
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


generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__sv8000_mode)
	and	a
	jp	nz,scrollup_hires
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
scrollup_hires:
	ld	de, DISPLAY
	ld	hl, DISPLAY + 256
	ld	bc, 32 * 88
	ldir
	ex	de,hl
	ld	b,0
	xor	a
scrollup_hires_1:
	ld	(hl),a
	inc	hl
	djnz	scrollup_hires_1
	pop	bc
	pop	de
	ret


