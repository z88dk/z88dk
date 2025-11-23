    MODULE  __printf_print_to_buf
    SECTION code_clib
    PUBLIC  __printf_print_to_buf

    EXTERN  __printf_get_buffer_address

    EXTERN  __printf_get_buffer_length
    EXTERN  __printf_inc_buffer_length

; Entry: a = character to print
__printf_print_to_buf:
    push    hl
    push    bc
    call    __printf_get_buffer_address
IF __CPU_INTEL__ | __CPU_GBZ80__
    push    de
    call    __printf_get_buffer_length
    ld      c,e
    pop     de
ELSE
    ld      c,(ix-10)
ENDIF
    ld      b,0
    add     hl,bc
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_inc_buffer_length
ELSE
    inc     (ix-10)
ENDIF
    ld      (hl),a
    pop     bc
    pop     hl
    ret
