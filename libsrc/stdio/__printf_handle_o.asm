
	MODULE	__printf_handle_o
	SECTION code_clib
	PUBLIC	__printf_handle_o
	EXTERN	__printf_number
	EXTERN	__printf_set_base

__printf_handle_o:
IF __CPU_8080__
	ld	c,8
	call	__printf_set_base
ELSE
	ld	(ix-9),8
ENDIF
	ld	c,0		;unsigned
	jp	__printf_number
