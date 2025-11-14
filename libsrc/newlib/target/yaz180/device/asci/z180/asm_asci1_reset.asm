
    SECTION code_driver

    PUBLIC asm_asci1_reset

    EXTERN asm_asci1_flush_Rx, asm_asci1_flush_Tx

    asm_asci1_reset:

        ; interrupts should be disabled
        
        call asm_asci1_flush_Rx
        call asm_asci1_flush_Tx

        ret

    EXTERN asm_asci1_need
    defc NEED = asm_asci1_need
