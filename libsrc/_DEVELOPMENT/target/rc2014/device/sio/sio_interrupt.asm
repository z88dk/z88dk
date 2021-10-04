
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN  siobRxBuffer
EXTERN  siobTxBuffer
EXTERN  sioaRxBuffer
EXTERN  sioaTxBuffer

EXTERN  siobRxCount, siobRxIn
EXTERN  siobTxCount, siobTxOut
EXTERN  sioaRxCount, sioaRxIn
EXTERN  sioaTxCount, sioaTxOut

PUBLIC  __siob_interrupt_tx_empty
PUBLIC  __siob_interrupt_ext_status
PUBLIC  __siob_interrupt_rx_char
PUBLIC  __siob_interrupt_rx_error
PUBLIC  __sioa_interrupt_tx_empty
PUBLIC  __sioa_interrupt_ext_status
PUBLIC  __sioa_interrupt_rx_char
PUBLIC  __sioa_interrupt_rx_error


__siob_interrupt_tx_empty:          ; start doing the SIOB Tx stuff
        push af
        ld a,(siobTxCount)          ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr Z,siob_tx_int_pend       ; if the count is zero, disable the Tx Interrupt and exit

        push hl
        ld hl,(siobTxOut)           ; get the pointer to place where we pop the Tx byte
        ld a,(hl)                   ; get the Tx byte
        out (__IO_SIOB_DATA_REGISTER),a ; output the Tx byte to the SIOB

        inc l                       ; move the Tx pointer, just low byte along
IF __IO_SIO_TX_SIZE != 0x100
        ld a,__IO_SIO_TX_SIZE-1     ; load the buffer size, (n^2)-1
        and l                       ; range check
        or siobTxBuffer&0xFF        ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (siobTxOut),hl           ; write where the next byte should be popped

        ld hl,siobTxCount
        dec (hl)                    ; atomically decrement current Tx count

        pop hl
        jr NZ,siob_tx_end

siob_tx_int_pend:
        ld a,__IO_SIO_WR0_TX_INT_PENDING_RESET  ; otherwise pend the Tx interrupt
        out (__IO_SIOB_CONTROL_REGISTER),a      ; into the SIOB register R0

siob_tx_end:                        ; if we've more Tx bytes to send, we're done for now
        pop af


__siob_interrupt_ext_status:
        ei
        reti


__siob_interrupt_rx_char:
        push af
        push hl

siob_rx_get:
        in a,(__IO_SIOB_DATA_REGISTER)  ; move Rx byte from the SIOB to A
        ld l,a                      ; put it in L

        ld a,(siobRxCount)          ; get the number of bytes in the Rx buffer      
        cp __IO_SIO_RX_SIZE-1       ; check whether there is space in the buffer
        jr NC,siob_rx_check         ; buffer full, check whether we need to drain H/W FIFO

        ld a,l                      ; get Rx byte from l

        ld hl,(siobRxIn)            ; get the pointer to where we poke
        ld (hl),a                   ; write the Rx byte to the siobRxIn target
        inc l                       ; move the Rx pointer low byte along
IF __IO_SIO_RX_SIZE != 0x100
        ld a,__IO_SIO_RX_SIZE-1     ; load the buffer size, (n^2)-1
        and l                       ; range check
        or siobRxBuffer&0xFF        ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (siobRxIn),hl            ; write where the next byte should be poked

        ld hl,siobRxCount
        inc (hl)                    ; atomically increment Rx buffer count

        ld a,(siobRxCount)          ; get the current Rx count
        cp __IO_SIO_RX_FULLISH      ; compare the count with the preferred full size
        jp NZ,siob_rx_check         ; if the buffer is fullish reset the RTS line
                                    ; this means getting characters will be slower
                                    ; when the buffer is fullish,
                                    ; but we stop the lemmings.

        ld a,__IO_SIO_WR0_R5        ; prepare for a write to R5
        out (__IO_SIOB_CONTROL_REGISTER),a  ; write to SIOB control register
        ld a,__IO_SIO_WR5_TX_DTR|__IO_SIO_WR5_TX_8BIT|__IO_SIO_WR5_TX_ENABLE    ; clear RTS
        out (__IO_SIOB_CONTROL_REGISTER),a  ; write the SIOB R5 register

siob_rx_check:                      ; SIO has 4 byte Rx H/W FIFO
        in a,(__IO_SIOB_CONTROL_REGISTER)   ; get the SIOB register R0
        rrca                        ; test whether we have received on SIOB
        jr C,siob_rx_get            ; if still more bytes in H/W FIFO, get them

        pop hl                      ; or clean up
        pop af
        ei
        reti


__siob_interrupt_rx_error:
        push af
        ld a,__IO_SIO_WR0_R1                ; set request for SIOB Read Register 1
        out (__IO_SIOB_CONTROL_REGISTER),a  ; into the SIOB control register
        in a,(__IO_SIOB_CONTROL_REGISTER)   ; load Read Register 1
                                            ; test whether we have error on SIOB
        and __IO_SIO_RR1_RX_FRAMING_ERROR|__IO_SIO_RR1_RX_OVERRUN|__IO_SIO_RR1_RX_PARITY_ERROR
        jr Z,siob_interrupt_rx_exit         ; clear error, and exit
        in a,(__IO_SIOB_DATA_REGISTER)      ; remove errored Rx byte from the SIOB

siob_interrupt_rx_exit:
        ld a,__IO_SIO_WR0_ERROR_RESET       ; otherwise reset the Error flags
        out (__IO_SIOB_CONTROL_REGISTER),a  ; in the SIOB Write Register 0
        pop af                              ; and clean up
        ei
        reti


__sioa_interrupt_tx_empty:          ; start doing the SIOA Tx stuff
        push af
        ld a,(sioaTxCount)          ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr Z,sioa_tx_int_pend       ; if the count is zero, disable the Tx Interrupt and exit

        push hl
        ld hl,(sioaTxOut)           ; get the pointer to place where we pop the Tx byte
        ld a,(hl)                   ; get the Tx byte
        out (__IO_SIOA_DATA_REGISTER),a ; output the Tx byte to the SIOA

        inc l                       ; move the Tx pointer, just low byte along
IF __IO_SIO_TX_SIZE != 0x100
        ld a,__IO_SIO_TX_SIZE-1     ; load the buffer size, (n^2)-1
        and l                       ; range check
        or sioaTxBuffer&0xFF        ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (sioaTxOut),hl           ; write where the next byte should be popped

        ld hl,sioaTxCount
        dec (hl)                    ; atomically decrement current Tx count

        pop hl
        jr NZ,sioa_tx_end

sioa_tx_int_pend:
        ld a,__IO_SIO_WR0_TX_INT_PENDING_RESET  ; otherwise pend the Tx interrupt
        out (__IO_SIOA_CONTROL_REGISTER),a      ; into the SIOA register R0

sioa_tx_end:                        ; if we've more Tx bytes to send, we're done for now
        pop af


__sioa_interrupt_ext_status:
        ei
        reti


__sioa_interrupt_rx_char:
        push af
        push hl

sioa_rx_get:
        in a,(__IO_SIOA_DATA_REGISTER)  ; move Rx byte from the SIOA to A
        ld l,a                      ; put it in L

        ld a,(sioaRxCount)          ; get the number of bytes in the Rx buffer      
        cp __IO_SIO_RX_SIZE-1       ; check whether there is space in the buffer
        jr NC,sioa_rx_check         ; buffer full, check whether we need to drain H/W FIFO

        ld a,l                      ; get Rx byte from l

        ld hl,(sioaRxIn)            ; get the pointer to where we poke
        ld (hl),a                   ; write the Rx byte to the sioaRxIn target

        inc l                       ; move the Rx pointer low byte along
IF __IO_SIO_RX_SIZE != 0x100
        ld a,__IO_SIO_RX_SIZE-1     ; load the buffer size, (n^2)-1
        and l                       ; range check
        or sioaRxBuffer&0xFF        ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (sioaRxIn),hl            ; write where the next byte should be poked

        ld hl,sioaRxCount
        inc (hl)                    ; atomically increment Rx buffer count

        ld a,(sioaRxCount)          ; get the current Rx count
        cp __IO_SIO_RX_FULLISH      ; compare the count with the preferred full size
        jp NZ,sioa_rx_check         ; if the buffer is fullish reset the RTS line
                                    ; this means getting characters will be slower
                                    ; when the buffer is fullish,
                                    ; but we stop the lemmings.

        ld a,__IO_SIO_WR0_R5        ; prepare for a write to R5
        out (__IO_SIOA_CONTROL_REGISTER),a   ; write to SIOA control register
        ld a,__IO_SIO_WR5_TX_DTR|__IO_SIO_WR5_TX_8BIT|__IO_SIO_WR5_TX_ENABLE    ; clear RTS
        out (__IO_SIOA_CONTROL_REGISTER),a  ; write the SIOA R5 register

sioa_rx_check:                      ; SIO has 4 byte Rx H/W FIFO
        in a,(__IO_SIOA_CONTROL_REGISTER)   ; get the SIOA register R0
        rrca                        ; test whether we have received on SIOA
        jr C,sioa_rx_get            ; if still more bytes in H/W FIFO, get them

        pop hl                      ; or clean up
        pop af
        ei
        reti


__sioa_interrupt_rx_error:
        push af
        ld a,__IO_SIO_WR0_R1                ; set request for SIOA Read Register 1
        out (__IO_SIOA_CONTROL_REGISTER),a  ; into the SIOA control register
        in a,(__IO_SIOA_CONTROL_REGISTER)   ; load Read Register 1
                                            ; test whether we have error on SIOA
        and __IO_SIO_RR1_RX_FRAMING_ERROR|__IO_SIO_RR1_RX_OVERRUN|__IO_SIO_RR1_RX_PARITY_ERROR
        jr Z,sioa_interrupt_rx_exit         ; clear error, and exit

        in a,(__IO_SIOA_DATA_REGISTER)      ; remove errored Rx byte from the SIOA

sioa_interrupt_rx_exit:
        ld a,__IO_SIO_WR0_ERROR_RESET       ; otherwise reset the Error flags
        out (__IO_SIOA_CONTROL_REGISTER),a  ; in the SIOA Write Register 0
        pop af                              ; and clean up
        ei
        reti

    EXTERN _sio_need
    defc NEED = _sio_need

