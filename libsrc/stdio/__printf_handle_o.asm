
	MODULE	__printf_handle_o
	SECTION code_clib
	PUBLIC	__printf_handle_o
	EXTERN	__printf_number

__printf_handle_o:
	ld	c,0		;unsigned
	ld	(ix-9),8
	jp	__printf_number
