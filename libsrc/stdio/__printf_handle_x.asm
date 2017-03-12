
	MODULE	__printf_handle_x
	SECTION code_clib
	PUBLIC	__printf_handle_x
	PUBLIC	__printf_handle_p
	EXTERN	__printf_number

__printf_handle_x:
__printf_handle_p:
	ld	c,0		;unsigned
	ld	(ix-9),16
        res     1,(ix-4)        ;disable '+' flag
	jp	__printf_number
