
SECTION code_driver
SECTION code_driver_character_input

PUBLIC _acia_flush_Rx_di
PUBLIC _acia_flush_Rx

EXTERN aciaRxCount, aciaRxBuffer, aciaRxIn, aciaRxOut

._acia_flush_Rx_di

    push af
    push hl

    di          ; di

    call _acia_flush_Rx

    ei          ; ei

    pop hl
    pop af

    ret

._acia_flush_Rx

    xor a
    ld (aciaRxCount),a          ; reset the Rx counter (set 0)

    ld hl,aciaRxBuffer          ; load Rx buffer pointer home
    ld (aciaRxIn),hl
    ld (aciaRxOut),hl

    ret

EXTERN _acia_need
defc NEED = _acia_need

