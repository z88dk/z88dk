
	MODULE	__printf_handle_B
	SECTION code_clib
	PUBLIC	__printf_handle_B
	EXTERN	__printf_number

__printf_handle_B:
	ld	c,0		;unsigned
        ld      (ix-9),2
        res     1,(ix-4)        ;disable '+' flag
	jp	__printf_number
