

		SECTION		code_clib

		PUBLIC		generic_console_scrollup

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x0800
                defc            TOPROW = DISPLAY + (CONSOLE_ROWS - 1) * 64


generic_console_scrollup:
	push	de
	push	bc
	; Move row 1 to row 0
	ld	hl, DISPLAY
	ld	de, TOPROW
	ld	bc, 64
	ldir
	; Move Row 2-15 to row 1-14
	ld	hl, DISPLAY + 64
	ld	de, DISPLAY
	ld	bc, 14 * 64
	ldir
	; And blank out row 15
	ex	de,hl
	ld	b,64
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret
