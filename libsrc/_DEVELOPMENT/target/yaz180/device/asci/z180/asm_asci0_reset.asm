
    SECTION code_driver

    PUBLIC asm_asci0_reset

    EXTERN asm_asci0_flush_Rx, asm_asci0_flush_Tx

    asm_asci0_reset:

        ; interrupts should be disabled
        
        call asm_asci0_flush_Rx
        call asm_asci0_flush_Tx

        ret

    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need
