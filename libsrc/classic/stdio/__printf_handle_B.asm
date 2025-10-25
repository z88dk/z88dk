    MODULE  __printf_handle_B
    SECTION code_clib
    PUBLIC  __printf_handle_B
    EXTERN  __printf_number

    EXTERN  __printf_set_base
    EXTERN  __printf_disable_plus_flag

__printf_handle_B:
IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      c,2
    call    __printf_set_base
    call    __printf_disable_plus_flag
ELSE
    ld      (ix-9),2
    res     1,(ix-4)        ;disable '+' flag
ENDIF
    ld      c,0		;unsigned
    jp      __printf_number
