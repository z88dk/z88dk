
	MODULE	__printf_handle_llx
	SECTION code_clib
	PUBLIC	__printf_handle_llx
	EXTERN	__printf_number64

__printf_handle_llx:
        ld      c,0             ;unsigned
        ld      (ix-9),16
        res     1,(ix-4)        ;disable '+' flag
	jp	__printf_number64
