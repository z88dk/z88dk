
	MODULE	__printf_print_to_buf
	SECTION code_clib
	PUBLIC  __printf_print_to_buf

	EXTERN	__printf_get_buffer_address

; Entry: a = character to print
__printf_print_to_buf:
        push    hl
        push    bc
        call    __printf_get_buffer_address
        ld      c,(ix-10)
        ld      b,0
        add     hl,bc
        inc     (ix-10)
        ld      (hl),a
        pop     bc
        pop     hl
        ret
