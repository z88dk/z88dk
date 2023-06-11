
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_input

PUBLIC _acia_getc

EXTERN aciaRxCount, aciaRxOut, aciaRxBuffer, aciaControl
EXTERN asm_z80_push_di, asm_z80_pop_ei

._acia_getc
    ; exit     : l = char received
    ;            carry reset if Rx buffer is empty
    ;
    ; modifies : af, hl

    ld a,(aciaRxCount)          ; get the number of bytes in the Rx buffer
    ld l,a                      ; and put it in hl
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    cp __IO_ACIA_RX_EMPTYISH    ; compare the count with the preferred empty size
    jp NZ,getc_clean_up_rx      ; if the buffer is too full, don't change the RTS

    di                          ; critical section begin
    ld a,(aciaControl)          ; get the ACIA control echo byte
    and ~__IO_ACIA_CR_TEI_MASK  ; mask out the Tx interrupt bits
    or __IO_ACIA_CR_TDI_RTS0    ; set RTS low.
    ld (aciaControl),a	        ; write the ACIA control echo byte back
    ei                          ; critical section end
    out (__IO_ACIA_CONTROL_REGISTER),a    ; set the ACIA CTRL register

.getc_clean_up_rx
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
    scf                         ; indicate char received
    ret

EXTERN _acia_need
defc NEED = _acia_need

