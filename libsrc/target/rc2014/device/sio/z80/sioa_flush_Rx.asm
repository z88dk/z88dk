
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _sioa_flush_Rx_di
    PUBLIC _sioa_flush_Rx

    EXTERN asm_z80_push_di, asm_z80_pop_ei
    EXTERN sioaRxCount, sioaRxIn, sioaRxOut, sioaRxBuffer

    _sioa_flush_Rx_di:

        push af
        push hl

        call asm_z80_push_di        ; di

        call _sioa_flush_Rx

        call asm_z80_pop_ei         ; ei

        pop hl
        pop af

        ret

    _sioa_flush_Rx:

        xor a
        ld (sioaRxCount),a          ; reset the Rx counter (set 0)  		

        ld hl,sioaRxBuffer          ; load Rx buffer pointer home
        ld (sioaRxIn),hl
        ld (sioaRxOut),hl

        ret

    EXTERN _sio_need
    defc NEED = _sio_need

