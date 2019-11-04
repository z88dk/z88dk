
    INCLUDE "config_private.inc"

    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC asm_asci0_interrupt
    
    EXTERN asci0RxBuffer, asci0RxCount, asci0RxIn
    EXTERN asci0TxBuffer, asci0TxCount, asci0TxOut

    asm_asci0_interrupt:
        push af
        push hl
                                    ; start doing the Rx stuff
        in0 a,(STAT0)               ; load the ASCI0 status register
        tst STAT0_RDRF              ; test whether we have received on ASCI0
        jr Z,ASCI0_TX_CHECK         ; if not, go check for bytes to transmit

ASCI0_RX_GET:
        in0 l,(RDR0)                ; move Rx byte from the ASCI0 RDR to l
        
        and STAT0_OVRN|STAT0_PE|STAT0_FE ; test whether we have error on ASCI0
        jr NZ,ASCI0_RX_ERROR        ; drop this byte, clear error, and get the next byte

        ld a,(asci0RxCount)         ; get the number of bytes in the Rx buffer      
        cp __ASCI0_RX_SIZE-1        ; check whether there is space in the buffer
        jr NC,ASCI0_RX_CHECK        ; buffer full, check whether we need to drain H/W FIFO

        ld a,l                      ; get Rx byte from l
        ld hl,(asci0RxIn)           ; get the pointer to where we poke
        ld (hl),a                   ; write the Rx byte to the asci0RxIn target

        inc l                       ; move the Rx pointer low byte along
IF __ASCI0_RX_SIZE != 0x100
        ld a,__ASCI0_RX_SIZE-1      ; load the buffer size, (n^2)-1
        and l                       ; range check
        or asci0RxBuffer&0xFF       ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (asci0RxIn),hl           ; write where the next byte should be poked

        ld hl, asci0RxCount
        inc (hl)                    ; atomically increment Rx buffer count
        jr ASCI0_RX_CHECK           ; check for additional bytes

ASCI0_RX_ERROR:
        in0 a,(CNTLA0)              ; get the CNTRLA0 register
        and ~  CNTLA0_EFR           ; to clear the error flag, EFR, to 0 
        out0 (CNTLA0),a             ; and write it back

ASCI0_RX_CHECK:                     ; Z8S180 has 4 byte Rx H/W FIFO
        in0 a,(STAT0)               ; load the ASCI0 status register
        tst STAT0_RDRF              ; test whether we have received on ASCI0
        jr NZ,ASCI0_RX_GET          ; if still more bytes in H/W FIFO, get them

ASCI0_TX_CHECK:                     ; now start doing the Tx stuff
        and STAT0_TDRE              ; test whether we can transmit on ASCI0
        jr Z,ASCI0_TX_END           ; if not, then end

        ld a,(asci0TxCount)         ; get the number of bytes in the Tx buffer
        or a                        ; check whether it is zero
        jr Z,ASCI0_TX_TIE0_CLEAR    ; if the count is zero, then disable the Tx Interrupt

        ld hl,(asci0TxOut)          ; get the pointer to place where we pop the Tx byte
        ld a,(hl)                   ; get the Tx byte
        out0 (TDR0),a               ; output the Tx byte to the ASCI0

        inc l                       ; move the Tx pointer low byte along
IF __ASCI0_TX_SIZE != 0x100
        ld a,__ASCI0_TX_SIZE-1      ; load the buffer size, (n^2)-1
        and l                       ; range check
        or asci0TxBuffer&0xFF       ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (asci0TxOut),hl          ; write where the next byte should be popped

        ld hl,asci0TxCount
        dec (hl)                    ; atomically decrement current Tx count
        jr NZ,ASCI0_TX_END          ; if we've more Tx bytes to send, we're done for now

ASCI0_TX_TIE0_CLEAR:
        in0 a,(STAT0)               ; get the ASCI0 status register
        and ~STAT0_TIE              ; mask out (disable) the Tx Interrupt
        out0 (STAT0),a              ; set the ASCI0 status register

ASCI0_TX_END:
        pop hl
        pop af
        ei
        ret

    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need
