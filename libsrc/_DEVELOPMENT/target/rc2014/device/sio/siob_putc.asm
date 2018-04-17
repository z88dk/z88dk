    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _siob_putc
    
    EXTERN __IO_SIOB_CONTROL_REGISTER, __IO_SIOB_DATA_REGISTER

    EXTERN __IO_SIO_RR0_TX_EMPTY
    EXTERN __IO_SIO_TX_SIZE

    EXTERN siobTxBuffer
    EXTERN siobTxCount, siobTxIn

    _siob_putc:
        ; enter    : l = char to output
        ; exit     : l = 1 if Tx buffer is full
        ;            carry reset
        ; modifies : af, hl

        di
        ld a,(siobTxCount)          ; get the number of bytes in the Tx buffer
        or a                        ; check whether the buffer is empty
        jr NZ,putc_buffer_tx        ; buffer not empty, so abandon immediate Tx

        in a,(__IO_SIOB_CONTROL_REGISTER)   ; get the SIOB register R0
        and __IO_SIO_RR0_TX_EMPTY   ; test whether we can transmit on SIOB
        jr Z,putc_buffer_tx         ; if not, so abandon immediate Tx

        ld a,l                      ; Retrieve Tx character for immediate Tx
        out (__IO_SIOB_DATA_REGISTER),a ; output the Tx byte to the SIOB

        ld l,0                      ; indicate Tx buffer was not full
        ei
        ret                         ; and just complete

    putc_buffer_tx:
        ld a,(siobTxCount)          ; Get the number of bytes in the Tx buffer
        cp __IO_SIO_TX_SIZE-1       ; check whether there is space in the buffer
        jp NC,putc_buffer_tx_overflow   ; buffer full, so drop the Tx byte and return

        ld a,l                      ; Tx byte
        ld hl,siobTxCount
        inc (hl)                    ; atomic increment of Tx count
        ld hl,(siobTxIn)            ; get the pointer to where we poke
        ei
        ld (hl),a                   ; write the Tx byte to the siobTxIn

        ld a,l                      ; check if Tx pointer is at the end of its range
        cp +(siobTxBuffer + __IO_SIO_TX_SIZE - 1)&0xff
        jr Z,putc_buffer_tx_reset   ; if at end of range, reset Tx pointer to start of Tx buffer
        inc hl                      ; else advance to next byte in Tx buffer

    putc_buffer_tx_exit:
        ld (siobTxIn), hl           ; write where the next byte should be poked
        ld l,0                      ; indicate Tx buffer was not full
        ret

    putc_buffer_tx_reset:
        ld hl,siobTxBuffer          ; move tx buffer pointer back to start of buffer
        jr putc_buffer_tx_exit

    putc_buffer_tx_overflow:
        ld l,1                      ; indicate Tx buffer was full
        ei
        ret


    EXTERN _sio_need
    defc NEED = _sio_need

