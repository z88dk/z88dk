
    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC _acia_putc
    
    EXTERN ACIA_STATUS_ADDR, ACIA_RDRF, ACIA_DATA_ADDR, ACIA_TX_SIZE
    EXTERN ACIA_TDRE, ACIA_TX_SIZE, ACIA_TEI_MASK, ACIA_TEI_RTS0, ACIA_CTRL_ADDR

    EXTERN aciaTxCount, aciaTxIn, aciaTxBuffer, aciaControl
    EXTERN asm_z80_push_di, asm_z80_pop_ei

    _acia_putc:

        ; enter    : l = char to output
        ; exit     : l = 1 if Tx buffer is full
        ;            carry reset
        ; modifies : af, hl

        ld a, (aciaTxCount)         ; Get the number of bytes in the Tx buffer
        or a                        ; check whether the buffer is empty
        jr nz, put_buffer_tx        ; buffer not empty, so abandon immediate Tx
        
        in a, (ACIA_STATUS_ADDR)    ; get the status of the ACIA
        and ACIA_TDRE               ; check whether a byte can be transmitted
        jr z, put_buffer_tx         ; if not, so abandon immediate Tx
        
        ld a, l                     ; Retrieve Tx character
        out (ACIA_DATA_ADDR), a     ; immediately output the Tx byte to the ACIA

        ld l, 0                     ; indicate Tx buffer was not full
        ret                         ; and just complete

    put_buffer_tx:

        ld a, (aciaTxCount)         ; Get the number of bytes in the Tx buffer
        cp ACIA_TX_SIZE             ; check whether there is space in the buffer
        ld a,l                      ; Tx byte

        ld l,1
        jr nc, clean_up_tx          ; buffer full, so drop the Tx byte and clean up

        ld hl, (aciaTxIn)           ; get the pointer to where we poke
        ld (hl), a                  ; write the Tx byte to the aciaTxIn   
        inc hl                      ; move the Tx pointer along

        ld a, l                     ; move low byte of the Tx pointer
        cp (aciaTxBuffer + ACIA_TX_SIZE) & $FF
        jr nz, put_no_tx_wrap
        ld hl, aciaTxBuffer         ; we wrapped, so go back to start of buffer

    put_no_tx_wrap:

        ld (aciaTxIn), hl           ; write where the next byte should be poked

        ld hl, aciaTxCount
        inc (hl)                    ; atomic increment of Tx count

        ld l, 0                     ; indicate Tx buffer was not full

    clean_up_tx:
        
        call asm_z80_push_di        ; critical section begin
        
        ld a, (aciaControl)         ; get the ACIA control echo byte
        and ~ACIA_TEI_MASK          ; mask out the Tx interrupt bits
        or ACIA_TEI_RTS0            ; set RTS low. if the TEI was not set, it will work again
        ld (aciaControl), a         ; write the ACIA control echo byte back
        out (ACIA_CTRL_ADDR), a     ; set the ACIA CTRL register
        
        call asm_z80_pop_ei         ; critical section end

        ret

    EXTERN _acia_need
    defc NEED = _acia_need
