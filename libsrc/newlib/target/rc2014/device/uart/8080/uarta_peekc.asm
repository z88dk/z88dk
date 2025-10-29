
SECTION code_driver
SECTION code_driver_character_input

PUBLIC _uarta_peekc

EXTERN uartaRxCount, uartaRxOut

._uarta_peekc
    ld a,(uartaRxCount)         ; get the number of bytes in the Rx buffer
    ld l,a                      ; and put it in hl
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    ld hl,(uartaRxOut)          ; get the pointer to place where we pop the Rx byte
    ld a,(hl)                   ; get the Rx byte
    ld l,a                      ; and put it in hl
    ret

EXTERN _uart_need
defc NEED = _uart_need
