
	MODULE	__printf_handle_X
	SECTION code_clib
	PUBLIC	__printf_handle_X
	EXTERN	__printf_number

__printf_handle_X:
	ld	c,0		;unsigned
	ld	(ix-9),16
	ld	(ix-3),'A' - 'a'
	jp	__printf_number
