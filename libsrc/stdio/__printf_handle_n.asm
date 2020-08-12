    MODULE  __printf_handle_n
    SECTION code_clib
    PUBLIC  __printf_handle_n
    EXTERN  __printf_loop
    EXTERN  get_16bit_ap_parameter

    EXTERN  __printf_write_chars_written


__printf_handle_n:
    push    hl              ;save format
    call    get_16bit_ap_parameter  ; de = ap, hl = value
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_write_chars_written
ELSE
    ld      a,(ix-2)
    ld      (hl),a
    ld      a,(ix-1)
    inc     hl
    ld      (hl),a
ENDIF
    pop     hl
    jp      __printf_loop
