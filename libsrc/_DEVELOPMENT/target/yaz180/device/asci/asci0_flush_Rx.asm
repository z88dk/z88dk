
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _asci0_flush_Rx_di
    PUBLIC _asci0_flush_Rx

    EXTERN asm_z180_push_di, asm_z180_pop_ei
    EXTERN asci0RxCount, asci0RxIn, asci0RxOut, asci0RxBuffer

    _asci0_flush_Rx_di:

        push af
        push hl

        call asm_z180_push_di       ; di

        call _asci0_flush_Rx

        call asm_z180_pop_ei        ; ei

        pop hl
        pop af

        ret

    _asci0_flush_Rx:

        xor a
        ld (asci0RxCount), a        ; reset the Rx counter (set 0)  		

        ld hl, asci0RxBuffer        ; load Rx buffer pointer home
        ld (asci0RxIn), hl
        ld (asci0RxOut), hl

        ret

    EXTERN _asci0_need
    defc NEED = _asci0_need
    
