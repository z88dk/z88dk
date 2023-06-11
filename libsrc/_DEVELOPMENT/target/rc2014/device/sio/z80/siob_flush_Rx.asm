
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _siob_flush_Rx_di
    PUBLIC _siob_flush_Rx

    EXTERN asm_z80_push_di, asm_z80_pop_ei
    EXTERN siobRxCount, siobRxIn, siobRxOut, siobRxBuffer

    _siob_flush_Rx_di:

        push af
        push hl

        call asm_z80_push_di        ; di

        call _siob_flush_Rx

        call asm_z80_pop_ei         ; ei

        pop hl
        pop af

        ret

    _siob_flush_Rx:

        xor a
        ld (siobRxCount),a          ; reset the Rx counter (set 0)  		

        ld hl,siobRxBuffer          ; load Rx buffer pointer home
        ld (siobRxIn),hl
        ld (siobRxOut),hl

        ret

    EXTERN _sio_need
    defc NEED = _sio_need

