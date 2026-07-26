
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _siob_flush_Tx_di
    PUBLIC _siob_flush_Tx

    EXTERN asm_z80_push_di, asm_z80_pop_ei
    EXTERN siobTxCount, siobTxIn, siobTxOut, siobTxBuffer

    _siob_flush_Tx_di:

        push af
        push hl

        call asm_z80_push_di        ; di

        call _siob_flush_Tx

        call asm_z80_pop_ei         ; ei

        pop hl
        pop af

        ret

    _siob_flush_Tx:

        xor a
        ld (siobTxCount),a          ; reset the Tx counter (set 0)

        ld hl,siobTxBuffer          ; load Tx buffer pointer home
        ld (siobTxIn),hl
        ld (siobTxOut),hl

        ret

    EXTERN _sio_need
    defc NEED = _sio_need

