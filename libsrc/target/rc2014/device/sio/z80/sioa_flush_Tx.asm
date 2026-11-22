
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _sioa_flush_Tx_di
    PUBLIC _sioa_flush_Tx

    EXTERN asm_z80_push_di, asm_z80_pop_ei
    EXTERN sioaTxCount, sioaTxIn, sioaTxOut, sioaTxBuffer

    _sioa_flush_Tx_di:

        push af
        push hl

        call asm_z80_push_di        ; di

        call _sioa_flush_Tx

        call asm_z80_pop_ei         ; ei

        pop hl
        pop af

        ret

    _sioa_flush_Tx:

        xor a
        ld (sioaTxCount),a          ; reset the Tx counter (set 0)

        ld hl,sioaTxBuffer          ; load Tx buffer pointer home
        ld (sioaTxIn),hl
        ld (sioaTxOut),hl

        ret

    EXTERN _sio_need
    defc NEED = _sio_need

