
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_cls

		EXTERN		__mc1000_mode

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CRT_FONT

		defc		DISPLAY = 0x8000

generic_console_cls:
	ld	a,(__mc1000_mode)
	cp	0x9e
	jr	z,hires_cls
	out	($80),a
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	set	0,a
	out	($80),a
	ret

hires_cls:
	ld	hl,DISPLAY
	ld	de,DISPLAY + 1
	ld	bc, 32 * 192 - 1
	out	($80),a
	ld	(hl),0
	ldir
	set	0,a
	out	($80),a
	ret

