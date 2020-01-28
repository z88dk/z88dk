
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC asm_asci0_flush_Tx

    EXTERN asci0TxCount, asci0TxIn, asci0TxOut, asci0TxBuffer

    asm_asci0_flush_Tx:
    
        xor a
        ld (asci0TxCount), a        ; reset the Tx counter (set 0)

        ld hl, asci0TxBuffer        ; load Tx buffer pointer home
        ld (asci0TxIn), hl
        ld (asci0TxOut), hl

        ret

    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need
