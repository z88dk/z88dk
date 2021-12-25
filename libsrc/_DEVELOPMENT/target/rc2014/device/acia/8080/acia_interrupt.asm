
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

PUBLIC _acia_interrupt

EXTERN aciaRxCount, aciaRxIn, aciaRxBuffer
EXTERN aciaTxCount, aciaTxOut, aciaTxBuffer, aciaControl

._acia_interrupt
    push af
    push hl

    in a,(__IO_ACIA_STATUS_REGISTER)  ; get the status of the ACIA
    rrca                        ; check whether a byte has been received, via __IO_ACIA_SR_RDRF
    jr NC,tx_send               ; if not, go check for bytes to transmit 

.rx_get
    in a,(__IO_ACIA_DATA_REGISTER)    ; Get the received byte from the ACIA 
    ld l,a                      ; move Rx byte to l

    ld a,(aciaRxCount)          ; Get the number of bytes in the Rx buffer
    cp __IO_ACIA_RX_SIZE-1      ; check whether there is space in the buffer
    jr NC,tx_check              ; buffer full, check if we can send something

    ld a,l                      ; get Rx byte from l
    ld hl,(aciaRxIn)            ; get the pointer to where we poke
    ld (hl),a                   ; write the Rx byte to the aciaRxIn address

    inc l                       ; move the Rx pointer low byte along
IF __IO_ACIA_RX_SIZE != 0x100
    ld a,__IO_ACIA_RX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or aciaRxBuffer&0xFF        ; locate base
    ld l,a                      ; return the low byte to l
ENDIF
    ld (aciaRxIn),hl            ; write where the next byte should be poked

    ld hl,aciaRxCount
    inc (hl)                    ; atomically increment Rx buffer count

    ld a,(aciaRxCount)          ; get the current Rx count
    cp __IO_ACIA_RX_FULLISH     ; compare the count with the preferred full size
    jp NZ,tx_check              ; leave the RTS low, and check for Rx/Tx possibility

    ld a,(aciaControl)          ; get the ACIA control echo byte
    and ~__IO_ACIA_CR_TEI_MASK  ; mask out the Tx interrupt bits
    or __IO_ACIA_CR_TDI_RTS1    ; set RTS high, and disable Tx Interrupt
    ld (aciaControl),a          ; write the ACIA control echo byte back
    out (__IO_ACIA_CONTROL_REGISTER),a  ; Set the ACIA CTRL register

.tx_check
    in a,(__IO_ACIA_STATUS_REGISTER)  ; get the status of the ACIA
    rrca                        ; check whether a byte has been received, via __IO_ACIA_SR_RDRF
    jr C,rx_get                 ; another byte received, go get it

.tx_send
    rrca                        ; check whether a byte can be transmitted, via __IO_ACIA_SR_TDRE
    jr NC,tx_end                ; if not, we're done for now

    ld a,(aciaTxCount)          ; get the number of bytes in the Tx buffer
    or a                        ; check whether it is zero
    jp Z,tx_tei_clear           ; if the count is zero, then disable the Tx Interrupt

    ld hl,(aciaTxOut)           ; get the pointer to place where we pop the Tx byte
    ld a,(hl)                   ; get the Tx byte
    out (__IO_ACIA_DATA_REGISTER),a ; output the Tx byte to the ACIA
    inc l                       ; move the Tx pointer, just low byte along
IF __IO_ACIA_TX_SIZE != 0x100
    ld a,__IO_ACIA_TX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or aciaTxBuffer&0xFF        ; locate base
    ld l,a                      ; return the low byte to l
ENDIF
    ld (aciaTxOut),hl           ; write where the next byte should be popped

    ld hl,aciaTxCount
    dec (hl)                    ; atomically decrement current Tx count

    jr NZ,tx_end                ; if we've more Tx bytes to send, we're done for now

.tx_tei_clear
    ld a,(aciaControl)          ; get the ACIA control echo byte
    and  ~__IO_ACIA_CR_TEI_RTS0    ; mask out (disable) the Tx Interrupt, keep RTS low
    ld (aciaControl),a          ; write the ACIA control byte back
    out (__IO_ACIA_CONTROL_REGISTER),a  ; Set the ACIA CTRL register

.tx_end
    pop hl
    pop af

    ei
    ret

EXTERN _acia_need
defc NEED = _acia_need
