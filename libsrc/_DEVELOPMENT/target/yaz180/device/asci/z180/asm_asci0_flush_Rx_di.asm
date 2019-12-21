
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC asm_asci0_flush_Rx_di

    EXTERN asm_z180_push_di, asm_z180_pop_ei
    EXTERN asm_asci0_flush_Rx

    asm_asci0_flush_Rx_di:

        push af
        push hl

        call asm_z180_push_di       ; di

        call asm_asci0_flush_Rx

        call asm_z180_pop_ei        ; ei

        pop hl
        pop af

        ret
