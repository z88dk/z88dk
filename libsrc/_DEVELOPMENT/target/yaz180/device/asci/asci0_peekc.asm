
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC asm_asci0_peekc

    EXTERN asci0RxCount, asci0RxOut

    asm_asci0_peekc:

        ld a,(asci0RxCount)         ; get the number of bytes in the Rx buffer
        ld l,a                      ; and put it in hl
        or a                        ; see if there are zero bytes available
        ret Z                       ; if the count is zero, then return

        ld hl,(asci0RxOut)          ; get the pointer to place where we pop the Rx byte
        ld a,(hl)                   ; get the Rx byte
        ld l,a                      ; and put it in hl
        ret

    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need
