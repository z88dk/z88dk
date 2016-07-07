
	MODULE	__printf_print_the_buffer
	SECTION	code_clib
	PUBLIC	__printf_print_the_buffer

	EXTERN	__printf_get_buffer_address
	EXTERN	__printf_loop
	EXTERN	__printf_print_aligned


__printf_print_the_buffer:
        ; On stack: ap, fmt
        ld      d,0
        ld      e,(ix-10)
        call    __printf_get_buffer_address
        ld      c,l                     ;bc=start of buffer
        ld      b,h
        call    __printf_print_aligned
        pop     de              ;ap
        pop     hl              ;fmt
        jp      __printf_loop
