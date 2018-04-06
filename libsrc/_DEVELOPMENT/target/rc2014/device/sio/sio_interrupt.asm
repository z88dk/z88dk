
    INCLUDE "config_private.inc"

    SECTION code_driver

    EXTERN  sioaRxCount, sioaRxIn
    EXTERN  sioaTxCount, sioaTxOut
    EXTERN  siobRxCount, siobRxIn
    EXTERN  siobTxCount, siobTxOut

    EXTERN  __sio_interrupt_vector_table
    
    PUBLIC  __sio_interrupt    

    PUBLIC  __siob_interrupt_tx_empty
    PUBLIC  __siob_interrupt_ext_status
    PUBLIC  __siob_interrupt_rx_char
    PUBLIC  __siob_interrupt_rx_error
    PUBLIC  __sioa_interrupt_tx_empty
    PUBLIC  __sioa_interrupt_ext_status
    PUBLIC  __sioa_interrupt_rx_char
    PUBLIC  __sioa_interrupt_rx_error

    __siob_interrupt_tx_empty:
    __siob_interrupt_ext_status:
    __siob_interrupt_rx_char:
    __siob_interrupt_rx_error:
    __sioa_interrupt_tx_empty:
    __sioa_interrupt_ext_status:
    __sioa_interrupt_rx_char:
    __sioa_interrupt_rx_error:

    __sio_interrupt:

;        push af
;        push hl
                                    ; start doing the Rx stuff
;        in0 a, (STAT0)              ; load the SIOA status register
;        tst STAT0_RDRF              ; test whether we have received on SIOA
;        jr z, SIO_TX_CHECK          ; if not, go check for bytes to transmit

SIO_RX_GET:
;        in0 l, (RDR0)               ; move Rx byte from the SIOA RDR to l
        
;        and STAT0_OVRN|STAT0_PE|STAT0_FE ; test whether we have error on SIOA
;        jr nz, SIO_RX_ERROR         ; drop this byte, clear error, and get the next byte

;        ld a, (sioaRxCount)         ; get the number of bytes in the Rx buffer      
;        cp __IO_SIO_RX_SIZE-1       ; check whether there is space in the buffer
;        jr nc, SIO_RX_CHECK         ; buffer full, check whether we need to drain H/W FIFO

;        ld a, l                     ; get Rx byte from l
;        ld hl, (sioaRxIn)           ; get the pointer to where we poke
;        ld (hl), a                  ; write the Rx byte to the sioaRxIn target

;        inc l                       ; move the Rx pointer low byte along, 0xFF rollover
;        ld (sioaRxIn), hl           ; write where the next byte should be poked

;        ld hl, sioaRxCount
;        inc (hl)                    ; atomically increment Rx buffer count
;        jr SIO_RX_CHECK             ; check for additional bytes

SIO_RX_ERROR:
;        in0 a, (CNTLA0)             ; get the CNTRLA0 register
;        and ~  CNTLA0_EFR           ; to clear the error flag, EFR, to 0 
;        out0 (CNTLA0), a            ; and write it back

SIO_RX_CHECK:                       ; Z8S180 has 4 byte Rx H/W FIFO
;        in0 a, (STAT0)              ; load the SIOA status register
;        tst STAT0_RDRF              ; test whether we have received on SIOA
;        jr nz, SIO_RX_GET           ; if still more bytes in H/W FIFO, get them

SIO_TX_CHECK:                       ; now start doing the Tx stuff
;        and STAT0_TDRE              ; test whether we can transmit on SIOA
;        jr z, SIO_TX_END            ; if not, then end

;        ld a, (sioaTxCount)         ; get the number of bytes in the Tx buffer
;        or a                        ; check whether it is zero
;        jr z, SIO_TX_TIE0_CLEAR     ; if the count is zero, then disable the Tx Interrupt

;        ld hl, (sioaTxOut)          ; get the pointer to place where we pop the Tx byte
;        ld a, (hl)                  ; get the Tx byte
;        out0 (TDR0), a              ; output the Tx byte to the SIOA

;        inc l                       ; move the Tx pointer low byte along, 0xFF rollover
;        ld (sioaTxOut), hl          ; write where the next byte should be popped

;        ld hl, sioaTxCount
;        dec (hl)                    ; atomically decrement current Tx count

;        jr nz, SIO_TX_END           ; if we've more Tx bytes to send, we're done for now

SIO_TX_TIE0_CLEAR:
;        in0 a, (STAT0)              ; get the SIOA status register
;        and ~STAT0_TIE              ; mask out (disable) the Tx Interrupt
;        out0 (STAT0), a             ; set the SIOA status register

SIO_TX_END:
;        pop hl
;        pop af

;        ei
;        reti

    EXTERN _sio_need
    defc NEED = _sio_need
