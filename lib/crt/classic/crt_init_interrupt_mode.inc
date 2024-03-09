
IF (__crt_interrupt_mode >= 0) && (__crt_interrupt_mode <= 2)
    ; set interrupt mode
    im __crt_interrupt_mode
ENDIF
