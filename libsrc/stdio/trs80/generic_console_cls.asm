

		SECTION		code_clib

		PUBLIC		generic_console_cls

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 15360


generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc,1023
	ld	(hl),32
	ldir
	ret
