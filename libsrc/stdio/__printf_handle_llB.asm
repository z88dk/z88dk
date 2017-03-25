
	MODULE	__printf_handle_llB
	SECTION code_clib
	PUBLIC	__printf_handle_llB
	EXTERN	__printf_number64

__printf_handle_llB:
        ld      c,0             ;unsigned
        ld      (ix-9),2
        res     1,(ix-4)        ;disable '+' flag
	jp	__printf_number64
