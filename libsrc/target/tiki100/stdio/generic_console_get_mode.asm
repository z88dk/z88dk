

	SECTION		code_graphics		;So himem
	PUBLIC		generic_console_get_mode

	INCLUDE		"target/cpm/def/tiki100.def"

generic_console_get_mode:
	ld	a,(PORT_0C_COPY)
	rrca
	rrca
	rrca
	rrca
	and	3
	ret
