
	MODULE	__printf_handle_llo
	SECTION code_clib
	PUBLIC	__printf_handle_llo
	EXTERN	__printf_number64

__printf_handle_llo:
        ld      c,0             ;unsigned
        ld      (ix-9),8
	jp	__printf_number64
