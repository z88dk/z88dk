
	MODULE	__printf_get_buffer_address
	SECTION code_clib
	PUBLIC	__printf_get_buffer_address

	EXTERN	__printf_context

; Gets the temporary buffer address
; Entry: ix = frame pointer
; Exit:  hl = address
; Uses:  bc
__printf_get_buffer_address:
IF __CPU_INTEL__
	ld	hl,(__printf_context)
ELSE
        push    ix
        pop     hl
ENDIF
        ld      bc,-80
        add     hl,bc
        ret
