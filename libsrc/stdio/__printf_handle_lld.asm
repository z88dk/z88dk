
	MODULE	__printf_handle_lld
	SECTION code_clib
	PUBLIC	__printf_handle_lld
	EXTERN	__printf_number64

__printf_handle_lld:
	ld	c,1		;signed
	jp	__printf_number64
