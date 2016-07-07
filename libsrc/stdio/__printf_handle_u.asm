
	MODULE	__printf_handle_u
	SECTION code_clib
	PUBLIC	__printf_handle_u
	EXTERN	__printf_number

__printf_handle_u:
	ld	c,0		;unsigned
	jp	__printf_number
