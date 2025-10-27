
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC asm_asci1_flush_Tx_di

    EXTERN asm_z180_push_di, asm_z180_pop_ei
    EXTERN asm_asci1_flush_Tx

    asm_asci1_flush_Tx_di:

        push af
        push hl

        call asm_z180_push_di       ; di
        
        call asm_asci1_flush_Tx
        
        call asm_z180_pop_ei        ; ei
    	
        pop hl
        pop af
    	
        ret
