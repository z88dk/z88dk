
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _asci1_flush_Tx_di
    PUBLIC _asci1_flush_Tx

    EXTERN asm_z180_push_di, asm_z180_pop_ei
    EXTERN asci1TxCount, asci1TxIn, asci1TxOut, asci1TxBuffer

    _asci1_flush_Tx_di:

        push af
        push hl

        call asm_z180_push_di       ; di
        
        call _asci1_flush_Tx
        
        call asm_z180_pop_ei        ; ei
    	
        pop hl
        pop af
    	
        ret

    _asci1_flush_Tx:
    
        xor a
        ld (asci1TxCount), a        ; reset the Tx counter (set 0)

        ld hl, asci1TxBuffer        ; load Tx buffer pointer home
        ld (asci1TxIn), hl
        ld (asci1TxOut), hl

        ret

    EXTERN _asci1_need
    defc NEED = _asci1_need

