

		SECTION		code_clib

		PUBLIC		generic_console_scrollup

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		D_FILE = 16396


generic_console_scrollup:
	push	de
	push	bc
	ld	hl,(D_FILE)
	inc	hl
	ld	d,h
	ld	e,l
	ld	bc,CONSOLE_COLUMNS + 1
	add	hl,bc
	ld	bc,+ ((CONSOLE_COLUMNS+1) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),0
	inc	hl
	djnz	generic_console_scrollup_3
	ld	(hl),0x76
	pop	bc
	pop	de
	ret
