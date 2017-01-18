
    SECTION code_driver
    SECTION code_driver_character_input

    PUBLIC _acia_getc

    EXTERN ACIA_RX_SIZE, ACIA_RX_FULLISH
    EXTERN ACIA_TEI_MASK, ACIA_TDI_RTS0, ACIA_CTRL_ADDR

    EXTERN aciaRxCount, aciaRxOut, aciaRxBuffer, aciaControl
    EXTERN asm_z80_push_di, asm_z80_pop_ei

    _acia_getc:

        ; exit     : l = char received
        ;            carry reset if Rx buffer is empty
        ;
        ; modifies : af, hl

        ld a, (aciaRxCount)         ; get the number of bytes in the Rx buffer
        ld l, a                     ; and put it in hl

        or a                        ; see if there are zero bytes available
        ret z                       ; if the count is zero, then return

        ld hl, (aciaRxOut)          ; get the pointer to place where we pop the Rx byte
        ld a, (hl)                  ; get the Rx byte
        push af                     ; save the Rx byte on stack

        inc hl                      ; move the Rx pointer along
        ld a, l                     ; get the low byte of the Rx pointer
        cp (aciaRxBuffer + ACIA_RX_SIZE) & $FF
        jr nz, get_no_rx_wrap
        ld hl, aciaRxBuffer         ; we wrapped, so go back to start of buffer

    get_no_rx_wrap:

        ld (aciaRxOut), hl          ; write where the next byte should be popped

        ld hl,aciaRxCount
        dec (hl)                    ; atomically decrement Rx count
        ld a,(hl)                   ; get the newly decremented Rx count

        cp ACIA_RX_FULLISH          ; compare the count with the preferred full size
        jr nc, get_clean_up_rx      ; if the buffer is full, don't change the RTS

        call asm_z80_push_di        ; critical section begin
        
        ld a, (aciaControl)         ; get the ACIA control echo byte
        and ~ACIA_TEI_MASK          ; mask out the Tx interrupt bits
        or ACIA_TDI_RTS0            ; set RTS low.
        ld (aciaControl), a	    ; write the ACIA control echo byte back
        out (ACIA_CTRL_ADDR), a     ; set the ACIA CTRL register
        
        call asm_z80_pop_ei         ; critical section end

    get_clean_up_rx:

        pop af                      ; get the Rx byte from stack
        ld l, a                     ; and put it in hl

        scf                         ; indicate char received
        ret

    EXTERN _acia_need
    defc NEED = _acia_need

