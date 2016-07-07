
	MODULE	__printf_handle_d
	SECTION code_clib
	PUBLIC	__printf_handle_d
	EXTERN	__printf_number

__printf_handle_d:
	ld	c,1		;signed
	jp	__printf_number
