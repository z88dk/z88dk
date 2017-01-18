
    SECTION code_driver

    PUBLIC _acia_interrupt
    
    EXTERN aciaRxCount, aciaRxIn, aciaRxBuffer
    EXTERN aciaTxCount, aciaTxOut, aciaTxBuffer, aciaControl

    EXTERN ACIA_STATUS_ADDR, ACIA_RDRF, ACIA_DATA_ADDR, ACIA_RX_SIZE, ACIA_RX_FULLISH
    EXTERN ACIA_TDRE, ACIA_TX_SIZE, ACIA_TEI_MASK, ACIA_TDI_RTS0, ACIA_CTRL_ADDR, ACIA_TDI_RTS1

    _acia_interrupt:

        push af
        push hl

    ; start doing the Rx stuff

        in a, (ACIA_STATUS_ADDR)    ; get the status of the ACIA
        and ACIA_RDRF               ; check whether a byte has been received
        jr z, tx_check              ; if not, go check for bytes to transmit 

        in a, (ACIA_DATA_ADDR)      ; Get the received byte from the ACIA 
        ld l, a                     ; Move Rx byte to l

        ld a, (aciaRxCount)         ; Get the number of bytes in the Rx buffer
        cp ACIA_RX_SIZE             ; check whether there is space in the buffer
        jr nc, tx_check             ; buffer full, check if we can send something

        ld a, l                     ; get Rx byte from l
        ld hl, (aciaRxIn)           ; get the pointer to where we poke
        ld (hl), a                  ; write the Rx byte to the aciaRxIn address

        inc hl                      ; move the Rx pointer along
        ld a, l	                    ; move low byte of the Rx pointer
        cp (aciaRxBuffer + ACIA_RX_SIZE) & $FF
        jr nz, no_rx_wrap
        ld hl, aciaRxBuffer         ; we wrapped, so go back to start of buffer

    no_rx_wrap:

        ld (aciaRxIn), hl           ; write where the next byte should be poked

        ld hl, aciaRxCount
        inc (hl)                    ; atomically increment Rx buffer count

    ; now start doing the Tx stuff

    tx_check:

        ld a, (aciaTxCount)         ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr z, tei_clear             ; if the count is zero, then disable the Tx Interrupt

        in a, (ACIA_STATUS_ADDR)    ; get the status of the ACIA
        and ACIA_TDRE               ; check whether a byte can be transmitted
        jr z, rts_check             ; if not, go check for the receive RTS selection

        ld hl, (aciaTxOut)          ; get the pointer to place where we pop the Tx byte
        ld a, (hl)                  ; get the Tx byte
        out (ACIA_DATA_ADDR), a     ; output the Tx byte to the ACIA

        inc hl                      ; move the Tx pointer along
        ld a, l                     ; get the low byte of the Tx pointer
        cp (aciaTxBuffer + ACIA_TX_SIZE) & $FF
        jr nz, no_tx_wrap
        ld hl, aciaTxBuffer         ; we wrapped, so go back to start of buffer

    no_tx_wrap:

        ld (aciaTxOut), hl          ; write where the next byte should be popped

        ld hl, aciaTxCount
        dec (hl)                    ; atomically decrement current Tx count
        jr nz, tx_end               ; if we've more Tx bytes to send, we're done for now
        
    tei_clear:

        ld a, (aciaControl)         ; get the ACIA control echo byte
        and ~ACIA_TEI_MASK          ; mask out the Tx interrupt bits
        or ACIA_TDI_RTS0            ; mask out (disable) the Tx Interrupt, keep RTS low
        ld (aciaControl), a         ; write the ACIA control byte back
        out (ACIA_CTRL_ADDR), a     ; Set the ACIA CTRL register

    rts_check:

        ld a, (aciaRxCount)         ; get the current Rx count    	
        cp ACIA_RX_FULLISH          ; compare the count with the preferred full size
        jr c, tx_end                ; leave the RTS low, and end

        ld a, (aciaControl)         ; get the ACIA control echo byte
        and ~ACIA_TEI_MASK          ; mask out the Tx interrupt bits
        or ACIA_TDI_RTS1            ; Set RTS high, and disable Tx Interrupt
        ld (aciaControl), a         ; write the ACIA control echo byte back
        out (ACIA_CTRL_ADDR), a	    ; Set the ACIA CTRL register

    tx_end:

        pop hl
        pop af
        
        ei
        reti

    EXTERN _acia_need
    defc NEED = _acia_need
