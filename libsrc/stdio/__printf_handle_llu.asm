
	MODULE	__printf_handle_llu
	SECTION code_clib
	PUBLIC	__printf_handle_llu
	EXTERN	__printf_number64

__printf_handle_llu:
	ld	c,0		;unsigned
	jp	__printf_number64
