
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_output

PUBLIC _acia_putc

EXTERN aciaTxCount, aciaTxIn, aciaTxBuffer, aciaControl
EXTERN asm_z80_push_di, asm_z80_pop_ei_jp

._acia_putc
    ; enter    : l = char to output
    ; exit     : l = 1 if Tx buffer is full
    ;            carry reset
    ; modifies : af, hl

    ld a,(aciaTxCount)          ; get the number of bytes in the Tx buffer
    or a                        ; check whether the buffer is empty
    jr NZ,putc_buffer_tx        ; buffer not empty, so abandon immediate Tx

    in a,(__IO_ACIA_STATUS_REGISTER)    ; get the status of the ACIA
    and __IO_ACIA_SR_TDRE       ; check whether a byte can be transmitted
    jr Z,putc_buffer_tx         ; if not, so abandon immediate Tx

    ld a,l                      ; retrieve Tx character
    out (__IO_ACIA_DATA_REGISTER),a     ; immediately output the Tx byte to the ACIA
    ld l,0                      ; indicate Tx buffer was not full
    ret                         ; and just complete

.putc_buffer_tx
    ld a,(aciaTxCount)          ; Get the number of bytes in the Tx buffer
    cp __IO_ACIA_TX_SIZE-1      ; check whether there is space in the buffer
    jr NC,putc_buffer_tx_overflow   ; buffer full, so drop the Tx byte and return

    ld a,l                      ; Tx byte

    ld hl,(aciaTxIn)            ; get the pointer to where we poke
    ld (hl),a                   ; write the Tx byte to the aciaTxIn

    inc l                       ; move the Tx pointer, just low byte along
IF __IO_ACIA_TX_SIZE != 0x100
    ld a,__IO_ACIA_TX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or aciaTxBuffer&0xFF        ; locate base
    ld l,a                      ; return the low byte to l
ENDIF
    ld (aciaTxIn),hl            ; write where the next byte should be poked

    ld hl,aciaTxCount
    inc (hl)                    ; atomic increment of Tx count

    ld l,0                      ; indicate Tx buffer was not full

.putc_buffer_tx_exit
    ld a,(aciaControl)          ; get the ACIA control echo byte
    and __IO_ACIA_CR_TEI_RTS0   ; test whether ACIA interrupt is set
    ret NZ                      ; if so then just return

    di                          ; critical section begin
    ld a,(aciaControl)          ; get the ACIA control echo byte
    and ~__IO_ACIA_CR_TEI_MASK  ; mask out the Tx interrupt bits
    or __IO_ACIA_CR_TEI_RTS0    ; set RTS low. if the TEI was not set, it will work again
    ld (aciaControl),a          ; write the ACIA control echo byte back
    out (__IO_ACIA_CONTROL_REGISTER),a    ; set the ACIA CTRL register
    ei                          ; critical section end
    ret

.putc_buffer_tx_overflow
    ld l,1                      ; indicate Tx buffer was full
    jr putc_buffer_tx_exit

EXTERN _acia_need
defc NEED = _acia_need
