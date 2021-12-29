
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"

SECTION code_driver

PUBLIC fgetc_cons_acia

EXTERN aciaRxCount, aciaRxOut, aciaRxBuffer
EXTERN aciaControl


.fgetc_cons_acia
    ; exit     : l = char received
    ;
    ; modifies : af, hl

    ld a,(aciaRxCount)          ; get the number of bytes in the Rx buffer
    or a                        ; see if there are zero bytes available
    jp Z,fgetc_cons_acia        ; wait, if there are no bytes available

    cp __IO_ACIA_RX_EMPTYISH    ; compare the count with the preferred empty size
    jp NZ,fgetc_cons_rx         ; if the buffer is too full, don't change the RTS

    di                          ; critical section begin
    ld a,(aciaControl)          ; get the ACIA control echo byte
    and ~__IO_ACIA_CR_TEI_MASK  ; mask out the Tx interrupt bits
    or __IO_ACIA_CR_TDI_RTS0    ; set RTS low.
    ld (aciaControl),a	        ; write the ACIA control echo byte back
    ei                          ; critical section end
    out (__IO_ACIA_CONTROL_REGISTER),a    ; set the ACIA CTRL register

.fgetc_cons_rx
    ld hl,(aciaRxOut)           ; get the pointer to place where we pop the Rx byte
    ld a,(hl)                   ; get the Rx byte

    inc l                       ; move the Rx pointer low byte along
IF __IO_ACIA_RX_SIZE != 0x100
    push af
    ld a,__IO_ACIA_RX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or aciaRxBuffer&0xFF        ; locate base
    ld l,a                      ; return the low byte to l
    pop af
ENDIF
    ld (aciaRxOut),hl           ; write where the next byte should be popped

    ld hl,aciaRxCount
    dec (hl)                    ; atomically decrement Rx count

    ld l,a                      ; and put it in hl
    ret
