
    SECTION code_driver

    PUBLIC _acia_interrupt
    
    EXTERN aciaRxCount, aciaRxIn, aciaRxBuffer
    EXTERN aciaTxCount, aciaTxOut, aciaTxBuffer, aciaControl

    EXTERN __IO_ACIA_CONTROL_REGISTER, __IO_ACIA_STATUS_REGISTER, __IO_ACIA_DATA_REGISTER
    EXTERN __IO_ACIA_CR_TEI_MASK, __IO_ACIA_CR_TDI_RTS0, __IO_ACIA_CR_TDI_RTS1, __IO_ACIA_SR_RDRF, __IO_ACIA_SR_TDRE
    EXTERN __IO_ACIA_RX_SIZE, __IO_ACIA_RX_FULLISH, __IO_ACIA_TX_SIZE

    _acia_interrupt:

        push af
        push hl

    ; start doing the Rx stuff

        in a, (__IO_ACIA_STATUS_REGISTER)  ; get the status of the ACIA
        and __IO_ACIA_SR_RDRF          ; check whether a byte has been received
        jr z, tx_check              ; if not, go check for bytes to transmit 

        in a, (__IO_ACIA_DATA_REGISTER)    ; Get the received byte from the ACIA 
        ld l, a                     ; Move Rx byte to l

        ld a, (aciaRxCount)         ; Get the number of bytes in the Rx buffer
        cp __IO_ACIA_RX_SIZE - 1    ; check whether there is space in the buffer
        jr nc, tx_check             ; buffer full, check if we can send something

        ld a, l                     ; get Rx byte from l
        ld hl, (aciaRxIn)           ; get the pointer to where we poke
        ld (hl), a                  ; write the Rx byte to the aciaRxIn address

        inc l                       ; move the Rx pointer low byte along, 0xFF rollover
        ld (aciaRxIn), hl           ; write where the next byte should be poked

        ld hl, aciaRxCount
        inc (hl)                    ; atomically increment Rx buffer count

    ; now start doing the Tx stuff

    tx_check:

        in a, (__IO_ACIA_STATUS_REGISTER)  ; get the status of the ACIA
        and __IO_ACIA_SR_TDRE       ; check whether a byte can be transmitted
        jr z, rts_check             ; if not, go check for the receive RTS selection

        ld a, (aciaTxCount)         ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr z, tei_clear             ; if the count is zero, then disable the Tx Interrupt

        ld hl, (aciaTxOut)          ; get the pointer to place where we pop the Tx byte
        ld a, (hl)                  ; get the Tx byte
        out (__IO_ACIA_DATA_REGISTER), a   ; output the Tx byte to the ACIA

        ld a,l                      ; check if Tx pointer is at the end of its range
        cp +(aciaTxBuffer + __IO_ACIA_TX_SIZE - 1) & 0xff
        jr z, resetTxBuffer         ; if at end of range, reset Tx pointer to start of Tx buffer
        inc hl                      ; else advance to next byte in Tx buffer

    tx_buffer_adjusted:
    
        ld (aciaTxOut), hl          ; write where the next byte should be popped

        ld hl, aciaTxCount
        dec (hl)                    ; atomically decrement current Tx count
        jr nz, tx_end               ; if we've more Tx bytes to send, we're done for now
        
    tei_clear:

        ld a, (aciaControl)         ; get the ACIA control echo byte
        and ~__IO_ACIA_CR_TEI_MASK  ; mask out the Tx interrupt bits
        or __IO_ACIA_CR_TDI_RTS0    ; mask out (disable) the Tx Interrupt, keep RTS low
        ld (aciaControl), a         ; write the ACIA control byte back
        out (__IO_ACIA_CONTROL_REGISTER), a   ; Set the ACIA CTRL register

    rts_check:

        ld a, (aciaRxCount)         ; get the current Rx count    	
        cp __IO_ACIA_RX_FULLISH        ; compare the count with the preferred full size
        jr c, tx_end                ; leave the RTS low, and end

        ld a, (aciaControl)         ; get the ACIA control echo byte
        and ~__IO_ACIA_CR_TEI_MASK  ; mask out the Tx interrupt bits
        or __IO_ACIA_CR_TDI_RTS1    ; Set RTS high, and disable Tx Interrupt
        ld (aciaControl), a         ; write the ACIA control echo byte back
        out (__IO_ACIA_CONTROL_REGISTER), a	; Set the ACIA CTRL register

    tx_end:

        pop hl
        pop af
        
        ei
        reti

    resetTxBuffer:
    
        ld hl,aciaTxBuffer          ; move tx buffer pointer back to start of buffer
        jp tx_buffer_adjusted

    EXTERN _acia_need
    defc NEED = _acia_need
