
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _acia_flush_Tx_di
    PUBLIC _acia_flush_Tx

    EXTERN asm_z80_push_di, asm_z80_pop_ei
    EXTERN aciaTxCount, aciaTxBuffer, aciaTxIn, aciaTxOut

    _acia_flush_Tx_di:

        push af
        push hl

        call asm_z80_push_di        ; di
        
        call _acia_flush_Tx
        
        call asm_z80_pop_ei         ; ei
    	
        pop hl
        pop af
    	
        ret

    _acia_flush_Tx:
    
        xor a
        ld (aciaTxCount),a          ; reset the Tx counter (set 0)

        ld hl,aciaTxBuffer          ; load Tx buffer pointer home
        ld (aciaTxIn),hl
        ld (aciaTxOut),hl

        ret

    EXTERN _acia_need
    defc NEED = _acia_need

