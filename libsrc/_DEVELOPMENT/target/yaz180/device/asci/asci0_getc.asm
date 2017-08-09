
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _asci0_getc

    EXTERN asci0RxCount, asci0RxOut

    _asci0_getc:

        ; exit     : l = char received
        ;            carry reset if Rx buffer is empty
        ;
        ; modifies : af, hl
        
        ld a, (asci0RxCount)        ; get the number of bytes in the Rx buffer
        or a                        ; see if there are zero bytes available
        ret z                       ; if the count is zero, then return

        ld hl, (asci0RxOut)         ; get the pointer to place where we pop the Rx byte
        ld a, (hl)                  ; get the Rx byte

        inc l                       ; move the Rx pointer low byte along, 0xFF rollover
        ld (asci0RxOut), hl         ; write where the next byte should be popped

        ld hl, asci0RxCount
        dec (hl)                    ; atomically decrement Rx count

        ld l, a                     ; put the byte in hl
        scf                         ; indicate char received
        ret

    EXTERN _asci0_need
    defc NEED = _asci0_need

