
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC asm_asci0_flush_Tx_di
    PUBLIC asm_asci0_flush_Tx

    EXTERN asm_z180_push_di, asm_z180_pop_ei
    EXTERN asci0TxCount, asci0TxIn, asci0TxOut, asci0TxBuffer

    asm_asci0_flush_Tx_di:

        push af
        push hl

        call asm_z180_push_di       ; di
        
        call asm_asci0_flush_Tx
        
        call asm_z180_pop_ei        ; ei
    	
        pop hl
        pop af
    	
        ret

    asm_asci0_flush_Tx:
    
        xor a
        ld (asci0TxCount), a        ; reset the Tx counter (set 0)

        ld hl, asci0TxBuffer        ; load Tx buffer pointer home
        ld (asci0TxIn), hl
        ld (asci0TxOut), hl

        ret

    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need

