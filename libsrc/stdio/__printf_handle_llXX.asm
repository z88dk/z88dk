
	MODULE	__printf_handle_llX
	SECTION code_clib
	PUBLIC	__printf_handle_llX
	EXTERN	__printf_number64

__printf_handle_llX:
        ld      c,0             ;unsigned
        ld      (ix-9),16
        ld      (ix-3),'A' - 'a'
        res     1,(ix-4)        ;disable '+' flag
	jp	__printf_number64
