

	SECTION		code_clib

	PUBLIC		gr_getmode
	PUBLIC		_gr_getmode
	EXTERN		generic_console_get_mode

	INCLUDE		"target/cpm/def/tiki100.def"

gr_getmode:
_gr_getmode:
	call	generic_console_get_mode
	ld	l,a
	ld	h,0
	ret

