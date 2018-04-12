

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 15360

generic_console_ioctl:
	scf
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc,1023
	ld	(hl),32
	ldir
	ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ld	(hl),a
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
