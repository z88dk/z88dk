
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN  siobTxBuffer
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
        push hl

        ld a,(siobTxCount)          ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr Z,siob_tx_int_pend       ; if the count is zero, disable the Tx Interrupt and exit

        ld hl,(siobTxOut)           ; get the pointer to place where we pop the Tx byte
        ld a,(hl)                   ; get the Tx byte
        out (__IO_SIOB_DATA_REGISTER),a ; output the Tx byte to the SIOB

        ld a,l                      ; check if Tx pointer is at the end of its range
        cp +(siobTxBuffer+__IO_SIO_TX_SIZE-1)&0xff
        jr Z,siob_tx_reset_buffer   ; if at end of range, reset Tx pointer to start of Tx buffer
        inc hl                      ; else advance to next byte in Tx buffer

siob_tx_buffer_adjusted:
        ld (siobTxOut),hl           ; write where the next byte should be popped

        ld hl,siobTxCount
        dec (hl)                    ; atomically decrement current Tx count

siob_tx_end:                        ; if we've more Tx bytes to send, we're done for now
        pop hl
        pop af

__siob_interrupt_ext_status:
        ei
        reti

siob_tx_int_pend:
        ld a,__IO_SIO_WR0_TX_INT_PENDING_RESET  ; otherwise pend the Tx interrupt
        out (__IO_SIOB_CONTROL_REGISTER),a      ; into the SIOB register R0
        jr siob_tx_end

siob_tx_reset_buffer:
        ld hl,siobTxBuffer         ; move tx buffer pointer back to start of buffer
        jr siob_tx_buffer_adjusted


__siob_interrupt_rx_char:
        push af
        push hl

siob_rx_get:
        in a,(__IO_SIOB_DATA_REGISTER)  ; move Rx byte from the SIOB to A
        ld l,a                      ; put it in L

        ld a,(siobRxCount)          ; get the number of bytes in the Rx buffer      
        cp __IO_SIO_RX_SIZE-1       ; check whether there is space in the buffer
        jr NC, siob_rx_check        ; buffer full, check whether we need to drain H/W FIFO

        ld a,l                      ; get Rx byte from l
        ld hl,(siobRxIn)            ; get the pointer to where we poke
        ld (hl),a                   ; write the Rx byte to the siobRxIn target

        inc l                       ; move the Rx pointer low byte along, 0xFF rollover
        ld (siobRxIn),hl            ; write where the next byte should be poked

        ld hl,siobRxCount
        inc (hl)                    ; atomically increment Rx buffer count

        ld a,(hl)                   ; get the current Rx count
        cp __IO_SIO_RX_FULLISH      ; compare the count with the preferred full size
        jr C, siob_rx_check         ; if the buffer is fullish reset the RTS line
                                    ; this means getting characters will be slower
                                    ; when the buffer is fullish,
                                    ; but we stop the lemmings.

        ld a,__IO_SIO_WR0_R5        ; prepare for a read from R5
        out (__IO_SIOB_CONTROL_REGISTER),a  ; write to SIOB control register
        in a,(__IO_SIOB_CONTROL_REGISTER)   ; read from the SIOB R5 register
        ld l,a                      ; put it in L
        
        ld a,__IO_SIO_WR0_R5        ; prepare for a write to R5
        out (__IO_SIOB_CONTROL_REGISTER),a  ; write to SIOB control register

        ld a,~__IO_SIO_WR5_RTS      ; clear RTS
        and l                       ; with previous contents of R5
        out (__IO_SIOB_CONTROL_REGISTER),a  ; write the SIOB R5 register

siob_rx_check:                      ; SIO has 4 byte Rx H/W FIFO
        xor a                       ; prepare to read from Read Register 0
        out (__IO_SIOB_CONTROL_REGISTER),a  ; into the SIOB control register
        in a,(__IO_SIOB_CONTROL_REGISTER)   ; get the SIOB register R0
        rrca                        ; test whether we have received on SIOB
        jr C,siob_rx_get            ; if still more bytes in H/W FIFO, get them

        ld a,__IO_SIO_WR0_RX_INT_FIRST_REENABLE ; otherwise reenable the Rx interrupt
        out (__IO_SIOB_CONTROL_REGISTER),a      ; into the SIOB control register

        pop hl                      ; and clean up
        pop af
        ei
        reti


__siob_interrupt_rx_error:
        push af
        push hl

        ld a,__IO_SIO_WR0_R1                ; set request for SIOB Read Register 1
        out (__IO_SIOB_CONTROL_REGISTER),a  ; into the SIOB control register
        in a,(__IO_SIOB_CONTROL_REGISTER)   ; load Read Register 1
                                            ; test whether we have error on SIOB
        and __IO_SIO_RR1_RX_FRAMING_ERROR|__IO_SIO_RR1_RX_OVERRUN|__IO_SIO_RR1_RX_PARITY_ERROR
        jr Z, siob_interrupt_rx_exit        ; clear error, and exit

        in a,(__IO_SIOB_DATA_REGISTER)      ; remove errored Rx byte from the SIOB

siob_interrupt_rx_exit:
        ld a,__IO_SIO_WR0_ERROR_RESET       ; otherwise reset the Error flags
        out (__IO_SIOB_CONTROL_REGISTER),a  ; in the SIOB Write Register 0

        pop hl                              ; and clean up
        pop af
        ei
        reti


__sioa_interrupt_tx_empty:          ; start doing the SIOA Tx stuff
        push af
        push hl

        ld a,(sioaTxCount)          ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr Z,sioa_tx_int_pend       ; if the count is zero, disable the Tx Interrupt and exit

        ld hl,(sioaTxOut)           ; get the pointer to place where we pop the Tx byte
        ld a,(hl)                   ; get the Tx byte
        out (__IO_SIOA_DATA_REGISTER),a ; output the Tx byte to the SIOA

        ld a,l                      ; check if Tx pointer is at the end of its range
        cp +(sioaTxBuffer+__IO_SIO_TX_SIZE-1)&0xff
        jr Z,sioa_tx_reset_buffer   ; if at end of range, reset Tx pointer to start of Tx buffer
        inc hl                      ; else advance to next byte in Tx buffer

sioa_tx_buffer_adjusted:
        ld (sioaTxOut),hl           ; write where the next byte should be popped

        ld hl,sioaTxCount
        dec (hl)                    ; atomically decrement current Tx count

sioa_tx_end:                        ; if we've more Tx bytes to send, we're done for now
        pop hl
        pop af

__sioa_interrupt_ext_status:
        ei
        reti

sioa_tx_int_pend:
        ld a,__IO_SIO_WR0_TX_INT_PENDING_RESET  ; otherwise pend the Tx interrupt
        out (__IO_SIOA_CONTROL_REGISTER),a      ; into the SIOA register R0
        jr sioa_tx_end

sioa_tx_reset_buffer:
        ld hl,sioaTxBuffer         ; move tx buffer pointer back to start of buffer
        jr sioa_tx_buffer_adjusted


__sioa_interrupt_rx_char:
        push af
        push hl

sioa_rx_get:
        in a,(__IO_SIOA_DATA_REGISTER)  ; move Rx byte from the SIOA to A
        ld l,a                      ; put it in L

        ld a,(sioaRxCount)          ; get the number of bytes in the Rx buffer      
        cp __IO_SIO_RX_SIZE-1       ; check whether there is space in the buffer
        jr NC, sioa_rx_check        ; buffer full, check whether we need to drain H/W FIFO

        ld a,l                      ; get Rx byte from l
        ld hl,(sioaRxIn)            ; get the pointer to where we poke
        ld (hl),a                   ; write the Rx byte to the sioaRxIn target

        inc l                       ; move the Rx pointer low byte along, 0xFF rollover
        ld (sioaRxIn),hl            ; write where the next byte should be poked

        ld hl,sioaRxCount
        inc (hl)                    ; atomically increment Rx buffer count

        ld a,(hl)                   ; get the current Rx count
        cp __IO_SIO_RX_FULLISH      ; compare the count with the preferred full size
        jr C, sioa_rx_check         ; if the buffer is fullish reset the RTS line
                                    ; this means getting characters will be slower
                                    ; when the buffer is fullish,
                                    ; but we stop the lemmings.

        ld a,__IO_SIO_WR0_R5        ; prepare for a read from R5
        out (__IO_SIOA_CONTROL_REGISTER),a  ; write to SIOA control register
        in a,(__IO_SIOA_CONTROL_REGISTER)   ; read from the SIOA R5 register
        ld l,a                      ; put it in L
        
        ld a,__IO_SIO_WR0_R5        ; prepare for a write to R5
        out (__IO_SIOA_CONTROL_REGISTER),a   ; write to SIOA control register

        ld a,~__IO_SIO_WR5_RTS      ; clear RTS
        and l                       ; with previous contents of R5
        out (__IO_SIOA_CONTROL_REGISTER),a  ; write the SIOA R5 register

sioa_rx_check:                      ; SIO has 4 byte Rx H/W FIFO
        xor a                       ; prepare to read from Read Register 0
        out (__IO_SIOA_CONTROL_REGISTER),a  ; into the SIOA control register
        in a,(__IO_SIOA_CONTROL_REGISTER)   ; get the SIOA register R0
        rrca                        ; test whether we have received on SIOA
        jr C,sioa_rx_get            ; if still more bytes in H/W FIFO, get them

        ld a,__IO_SIO_WR0_RX_INT_FIRST_REENABLE ; otherwise reenable the Rx interrupt
        out (__IO_SIOA_CONTROL_REGISTER),a      ; into the SIOA control register

        pop hl                      ; and clean up
        pop af
        ei
        reti


__sioa_interrupt_rx_error:
        push af
        push hl

        ld a,__IO_SIO_WR0_R1                ; set request for SIOA Read Register 1
        out (__IO_SIOA_CONTROL_REGISTER),a  ; into the SIOA control register
        in a,(__IO_SIOA_CONTROL_REGISTER)   ; load Read Register 1
                                            ; test whether we have error on SIOA
        and __IO_SIO_RR1_RX_FRAMING_ERROR|__IO_SIO_RR1_RX_OVERRUN|__IO_SIO_RR1_RX_PARITY_ERROR
        jr Z, sioa_interrupt_rx_exit        ; clear error, and exit

        in a,(__IO_SIOA_DATA_REGISTER)      ; remove errored Rx byte from the SIOA

sioa_interrupt_rx_exit:
        ld a,__IO_SIO_WR0_ERROR_RESET       ; otherwise reset the Error flags
        out (__IO_SIOA_CONTROL_REGISTER),a  ; in the SIOA Write Register 0

        pop hl                              ; and clean up
        pop af
        ei
        reti


    EXTERN _sio_need
    defc NEED = _sio_need

