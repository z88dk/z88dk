
    INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC  fputc_cons_uarta

.fputc_cons_uarta
    ; enter    : (sp+2) = char to output
    ;
    ; modifies : af, de, hl

    ; check space is available in the Tx FIFO
    in a,(__IO_UARTA_LSR_REGISTER)      ; read the line status register
    and __IO_UART_LSR_TX_HOLDING_THRE   ; check the THRE is available
    jp Z,fputc_cons_uarta               ; keep trying until THR has space
    
    ld de, sp+2                         ; retrieve Tx character
    ld a, (de)
    out (__IO_UARTA_DATA_REGISTER),a    ; output the Tx byte to the UART A
    ret                                 ; and just complete

