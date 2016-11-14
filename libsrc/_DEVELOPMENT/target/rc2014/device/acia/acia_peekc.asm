
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _acia_peekc

    EXTERN aciaRxCount, aciaRxOut

    _acia_peekc:

        ld a, (aciaRxCount)         ; get the number of bytes in the Rx buffer
        ld l, a                     ; and put it in hl
        or a                        ; see if there are zero bytes available
        ret z                       ; if the count is zero, then return

        ld hl, (aciaRxOut)          ; get the pointer to place where we pop the Rx byte
        ld a, (hl)                  ; get the Rx byte
        ld l, a                     ; and put it in hl
        ret

    EXTERN _acia_need
    defc NEED = _acia_need
