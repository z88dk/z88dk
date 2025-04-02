
    INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver
    SECTION code_driver_character_output

    PUBLIC  fputc_cons_uarta

EXTERN uartaControl

.fputc_cons_uarta
    ; enter    : (sp+2) = char to output
    ;
    ; modifies : af, de, hl

    ; check the UART A channel exists
    ld a,(uartaControl)                 ; load the control flag
    or a                                ; check it is non-zero
    ret Z                               ; return if it doesn't exist

    ld de,sp+2                          ; retrieve Tx character
    ld a,(de)
    ld e,a

IF STANDARDESCAPECHARS
    cp 10                               ; LF ?
    jp NZ,fputc_cons_immediate
    ld e,13                             ; CR
    call fputc_cons_immediate
    ld e,10                             ; LF
ELSE
    cp 13                               ; CR ?
    jp NZ,fputc_cons_immediate
    call fputc_cons_immediate
    ld e,10                             ; LF
ENDIF

.fputc_cons_immediate
    ; check space is available in the Tx FIFO
    in a,(__IO_UARTA_LSR_REGISTER)      ; read the line status register
    and __IO_UART_LSR_TX_HOLDING_THRE   ; check the THRE is available
    jp Z,fputc_cons_immediate           ; keep trying until THR has space

    ld a,e                              ; retrieve Tx character
    out (__IO_UARTA_DATA_REGISTER),a    ; output the Tx byte to the UART A
    ret                                 ; and just complete

