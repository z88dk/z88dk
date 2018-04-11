

		SECTION		code_clib

		PUBLIC		generic_console_cls

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		D_FILE = 16396


generic_console_cls:
	ld	hl,(D_FILE)
	inc	hl
	ld	c,CONSOLE_ROWS
generic_console_cls_1:
	ld	b,CONSOLE_COLUMNS
generic_console_cls_2:
	ld	(hl),0
	inc	hl
	djnz	generic_console_cls_2
	ld	(hl),0x76
	inc	hl
	dec	c
	jr	nz,generic_console_cls_1
	ret
