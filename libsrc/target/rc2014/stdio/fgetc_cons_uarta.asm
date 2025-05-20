
    INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"

    SECTION code_driver

    PUBLIC  fgetc_cons_uarta

    EXTERN uartaRxCount, uartaRxOut, uartaRxBuffer

.fgetc_cons_uarta
    ; exit     : l = char received
    ;
    ; modifies : af, hl

    ld a,(uartaRxCount)         ; get the number of bytes in the Rx buffer
    or a                        ; see if there are zero bytes available
    jp Z,fgetc_cons_uarta       ; if the count is zero, then wait

    cp __IO_UART_RX_EMPTYISH    ; compare the count with the preferred empty size
    jp NZ,getc_clean_up_rx      ; if the buffer is too full, don't change the RTS

    in a,(__IO_UARTA_MCR_REGISTER)  ; get the UART A MODEM Control Register
    or __IO_UART_MCR_RTS|__IO_UART_MCR_DTR  ; set RTS and DTR low
    out (__IO_UARTA_MCR_REGISTER),a ; set the MODEM Control Register

.getc_clean_up_rx
    ld hl,(uartaRxOut)          ; get the pointer to place where we pop the Rx byte
    ld a,(hl)                   ; get the Rx byte

    inc l                       ; move the Rx pointer low byte along
IF __IO_UART_RX_SIZE != 0x100
    push af
    ld a,__IO_UART_RX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or uartaRxBuffer&0xFF       ; locate base
    ld l,a                      ; return the low byte to l
    pop af
ENDIF
    ld (uartaRxOut),hl          ; write where the next byte should be popped

    ld hl,uartaRxCount
    dec (hl)                    ; atomically decrement Rx count

IF STANDARDESCAPECHARS
    cp 13                       ; CR ?
    ld hl,10                    ; LF
    ret Z
    cp 10                       ; LF ?
    ld hl,13                    ; CR
    ret Z
ENDIF

    ld l,a                      ; and put it in hl
    ld h,0
    ret
