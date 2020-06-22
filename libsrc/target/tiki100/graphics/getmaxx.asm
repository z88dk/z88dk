

	SECTION		code_graphics

	PUBLIC		getmaxx
	PUBLIC		_getmaxx

	EXTERN		generic_console_get_mode


getmaxx:
_getmaxx:
	call	generic_console_get_mode
	ld	hl,255
	cp	3
	ret	z
	ld	hl,511
	cp	2
	ret	z
	ld	hl,1023
	ret

