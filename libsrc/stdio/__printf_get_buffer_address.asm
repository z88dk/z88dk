
	MODULE	__printf_get_buffer_address
	SECTION code_clib
	PUBLIC	__printf_get_buffer_address

; Gets the temporary buffer address
; Entry: ix = frame pointer
; Exit:  hl = address
; Uses:  bc
__printf_get_buffer_address:
        push    ix
        pop     hl
        ld      bc,-80
        add     hl,bc
        ret
