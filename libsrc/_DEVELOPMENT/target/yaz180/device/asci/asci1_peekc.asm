
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _asci1_peekc

    EXTERN asci1RxCount, asci1RxOut

    _asci1_peekc:

        ld a, (asci1RxCount)        ; get the number of bytes in the Rx buffer
        ld l, a                     ; and put it in hl
        or a                        ; see if there are zero bytes available
        ret z                       ; if the count is zero, then return

        ld hl, (asci1RxOut)         ; get the pointer to place where we pop the Rx byte
        ld a, (hl)                  ; get the Rx byte
        ld l, a                     ; and put it in hl
        ret

    EXTERN _asci1_need
    defc NEED = _asci1_need
