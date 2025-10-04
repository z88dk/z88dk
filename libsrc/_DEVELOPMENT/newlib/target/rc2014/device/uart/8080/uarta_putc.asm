
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_output

PUBLIC _uarta_putc

EXTERN uartaControl

._uarta_putc
    ; enter    : l = char to output
    ; exit     : l = 1 if Tx buffer is full
    ;            carry reset
    ; modifies : af, hl

    ; check the UART A channel exists
    ld a,(uartaControl)         ; load the control flag
    or a                        ; check it is non-zero
    ret Z                       ; return if it doesn't exist

._uarta_putc_loop
    ; check space is available in the Tx FIFO
    in a,(__IO_UARTA_LSR_REGISTER)      ; read the line status register
    and __IO_UART_LSR_TX_HOLDING_THRE   ; check the THRE is available
    jp Z,_uarta_putc_loop               ; keep trying until THR has space

    ld a,l                              ; retrieve Tx character
    out (__IO_UARTA_DATA_REGISTER),a    ; output the Tx byte to the UART A
    ld l,0                              ; indicate Tx buffer was not full
    ret                                 ; and just complete

EXTERN _uart_need
defc NEED = _uart_need
