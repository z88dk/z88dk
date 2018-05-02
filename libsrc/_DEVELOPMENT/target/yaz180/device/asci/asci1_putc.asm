    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _asci1_putc
    
    EXTERN STAT1, TDR1
    EXTERN STAT1_TDRE, STAT1_TIE
    
    EXTERN __ASCI1_TX_SIZE

    EXTERN asci1TxCount, asci1TxIn

    _asci1_putc:
        ; enter    : l = char to output
        ; exit     : l = 1 if Tx buffer is full
        ;            carry reset
        ; modifies : af, hl
        ld a,(asci1TxCount)         ; get the number of bytes in the Tx buffer
        or a                        ; check whether the buffer is empty
        jr NZ,put_buffer_tx         ; buffer not empty, so abandon immediate Tx

        in0 a,(STAT1)               ; get the ASCI1 status register
        and STAT1_TDRE              ; test whether we can transmit on ASCI1
        jr Z,put_buffer_tx          ; if not, so abandon immediate Tx

        out0 (TDR1),l               ; output the Tx byte to the ASCI1

        ld l,0                      ; indicate Tx buffer was not full
        ret                         ; and just complete

    put_buffer_tx:
        ld a,(asci1TxCount)         ; Get the number of bytes in the Tx buffer
        cp __ASCI1_TX_SIZE - 1      ; check whether there is space in the buffer
        ld a,l                      ; Tx byte

        ld l,1
        jr NC,clean_up_tx           ; buffer full, so drop the Tx byte and clean up

        ld hl,asci1TxCount
        di
        inc (hl)                    ; atomic increment of Tx count
        ld hl,(asci1TxIn)           ; get the pointer to where we poke
        ei
        ld (hl),a                   ; write the Tx byte to the asci1TxIn

        inc l                       ; move the Tx pointer low byte along, 0xFF rollover
        ld (asci1TxIn),hl           ; write where the next byte should be poked

        ld l,0                      ; indicate Tx buffer was not full

    clean_up_tx:
        in0 a,(STAT1)               ; load the ASCI1 status register
        and STAT1_TIE               ; test whether ASCI1 interrupt is set
        ret NZ                      ; if so then just return

        di                          ; critical section begin
        in0 a,(STAT1)               ; get the ASCI status register again
        or STAT1_TIE                ; mask in (enable) the Tx Interrupt
        out0 (STAT1),a              ; set the ASCI status register
        ei                          ; critical section end
        ret


    EXTERN _asci1_need
    defc NEED = _asci1_need
