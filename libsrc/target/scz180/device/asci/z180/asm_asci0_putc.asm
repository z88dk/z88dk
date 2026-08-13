
    INCLUDE "config_private.inc"

    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC asm_asci0_putc

    EXTERN asci0TxBuffer, asci0TxCount, asci0TxIn

    asm_asci0_putc:
        ; enter    : l = char to output
        ; exit     : l = 1 if Tx buffer is full
        ;            carry reset
        ; modifies : af, hl
        ld a,(asci0TxCount)         ; get the number of bytes in the Tx buffer
        or a                        ; check whether the buffer is empty
        jr NZ,put_buffer_tx         ; buffer not empty, so abandon immediate Tx

        di
        in0 a,(STAT0)               ; get the ASCI0 status register
        and STAT0_TDRE              ; test whether we can transmit on ASCI0
        jr Z,put_buffer_tx_ei       ; if not, so abandon immediate Tx
        out0 (TDR0),l               ; output the Tx byte to the ASCI0
        ld l,0                      ; indicate Tx buffer was not full
        ei
        ret                         ; and just complete

    put_buffer_tx_ei:
        ei
    put_buffer_tx:
        ld a,(asci0TxCount)         ; Get the number of bytes in the Tx buffer
        cp __ASCI0_TX_SIZE - 1      ; check whether there is space in the buffer
        ld a,l                      ; Tx byte

        ld l,1
        jr NC,clean_up_tx           ; buffer full, so drop the Tx byte and clean up

        ld hl,asci0TxCount
        di
        inc (hl)                    ; atomic increment of Tx count
        ld hl,(asci0TxIn)           ; get the pointer to where we poke
        ei
        ld (hl),a                   ; write the Tx byte to the asci0TxIn

        inc l                       ; move the Tx pointer low byte along
IF __ASCI0_TX_SIZE != 0x100
        ld a,__ASCI0_TX_SIZE-1      ; load the buffer size, (n^2)-1
        and l                       ; range check
        or asci0TxBuffer&0xFF       ; locate base
        ld l,a                      ; return the low byte to l
ENDIF
        ld (asci0TxIn),hl           ; write where the next byte should be poked

        ld l,0                      ; indicate Tx buffer was not full

    clean_up_tx:
        in0 a,(STAT0)               ; load the ASCI0 status register
        and STAT0_TIE               ; test whether ASCI0 interrupt is set
        ret NZ                      ; if so then just return

        di                          ; critical section begin
        in0 a,(STAT0)               ; get the ASCI status register again
        or STAT0_TIE                ; mask in (enable) the Tx Interrupt
        out0 (STAT0),a              ; set the ASCI status register
        ei                          ; critical section end
        ret


    EXTERN asm_asci0_need
    defc NEED = asm_asci0_need
