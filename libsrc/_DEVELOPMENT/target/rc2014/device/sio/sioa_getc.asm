
    INCLUDE "config_private.inc"

    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _sioa_getc

    EXTERN sioaRxBuffer
    EXTERN sioaRxCount, sioaRxOut

    _sioa_getc:

        ; exit     : l = char received
        ;            carry reset if Rx buffer is empty
        ;
        ; modifies : af, hl

        ld a,(sioaRxCount)          ; get the number of bytes in the Rx buffer
        or a                        ; see if there are zero bytes available
        ret Z                       ; if the count is zero, then return

        cp __IO_SIO_RX_EMPTYISH     ; compare the count with the preferred empty size
        jp NZ,getc_clean_up         ; if the buffer NOT emptyish, don't change the RTS
                                    ; this means retrieving characters will be slower
                                    ; when the buffer is emptyish.
                                    ; Better than the reverse case.

        ld a,__IO_SIO_WR0_R5        ; prepare for a write to R5
        out (__IO_SIOA_CONTROL_REGISTER),a  ; write to SIOA control register
        ld a,__IO_SIO_WR5_TX_DTR|__IO_SIO_WR5_TX_8BIT|__IO_SIO_WR5_TX_ENABLE|__IO_SIO_WR5_RTS   ; set the RTS
        out (__IO_SIOA_CONTROL_REGISTER),a  ; write the SIOA R5 register

    getc_clean_up:
        ld hl,(sioaRxOut)           ; get the pointer to place where we pop the Rx byte
        ld a,(hl)                   ; get the Rx byte

        inc l                       ; move the Rx pointer low byte along
IF __IO_SIO_RX_SIZE != 0x100
        push af
        ld a,__IO_SIO_RX_SIZE-1     ; load the buffer size, (n^2)-1
        and l                       ; range check
        or sioaRxBuffer&0xFF        ; locate base
        ld l,a                      ; return the low byte to l
        pop af
ENDIF
        ld (sioaRxOut),hl           ; write where the next byte should be popped

        ld hl,sioaRxCount
        dec (hl)                    ; atomically decrement Rx count

        ld l,a                      ; put the byte in hl
        scf                         ; indicate char received
        ret

    EXTERN _sio_need
    defc NEED = _sio_need

