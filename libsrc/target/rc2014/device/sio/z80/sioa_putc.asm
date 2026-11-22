
    INCLUDE "config_private.inc"

    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _sioa_putc

    EXTERN sioaTxBuffer
    EXTERN sioaTxCount, sioaTxIn

    _sioa_putc:
        ; enter    : l = char to output
        ; exit     : l = 1 if Tx buffer is full
        ;            carry reset
        ; modifies : af, hl

        di
        ld a,(sioaTxCount)          ; get the number of bytes in the Tx buffer
        or a                        ; check whether the buffer is empty
        jr NZ,putc_buffer_tx        ; buffer not empty, so abandon immediate Tx

        in a,(__IO_SIOA_CONTROL_REGISTER)   ; get the SIOA register R0
        and __IO_SIO_RR0_TX_EMPTY   ; test whether we can transmit on SIOA
        jr Z,putc_buffer_tx         ; if not, so abandon immediate Tx

        ld a,l                      ; Retrieve Tx character for immediate Tx
        out (__IO_SIOA_DATA_REGISTER),a ; output the Tx byte to the SIOA

        ld l,0                      ; indicate Tx buffer was not full
        ei
        ret                         ; and just complete

    putc_buffer_tx:
        ld a,(sioaTxCount)          ; Get the number of bytes in the Tx buffer
        cp __IO_SIO_TX_SIZE-1       ; check whether there is space in the buffer
        jr NC,putc_buffer_tx_overflow   ; buffer full, so drop the Tx byte and return

        ld a,l                      ; Tx byte

        ld hl,sioaTxCount
        inc (hl)                    ; atomic increment of Tx count
        ld hl,(sioaTxIn)            ; get the pointer to where we poke
        ei
        ld (hl),a                   ; write the Tx byte to the sioaTxIn

        inc l                       ; move the Tx pointer, just low byte along
IF __IO_SIO_TX_SIZE != 0x100
        ld a,__IO_SIO_TX_SIZE-1     ; load the buffer size, (n^2)-1
        and l                       ; range check
        or sioaTxBuffer&0xFF        ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (sioaTxIn),hl            ; write where the next byte should be poked
        ld l,0                      ; indicate Tx buffer was not full
        ret

    putc_buffer_tx_overflow:
        ld l,1                      ; indicate Tx buffer was full
        ei
        ret

    EXTERN _sio_need
    defc NEED = _sio_need

