
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_input

PUBLIC _uartb_getc

EXTERN uartbRxCount, uartbRxOut, uartbRxBuffer

._uartb_getc
    ; exit     : l = char received
    ;            carry reset if Rx buffer is empty
    ;
    ; modifies : af, bc, hl

    ld a,(uartbRxCount)         ; get the number of bytes in the Rx buffer
    ld l,a                      ; and put it in hl
    or a                        ; see if there are zero bytes available
    ret Z                       ; if the count is zero, then return

    cp __IO_UART_RX_EMPTYISH    ; compare the count with the preferred empty size
    jp NZ,getc_clean_up_rx      ; if the buffer is too full, don't change the RTS

    in a,(__IO_UARTB_MCR_REGISTER)  ; get the UART B MODEM Control Register
    or __IO_UART_MCR_RTS|__IO_UART_MCR_DTR  ; set RTS and DTR low
    out (__IO_UARTB_MCR_REGISTER),a ; set the MODEM Control Register

.getc_clean_up_rx
    ld hl,(uartbRxOut)          ; get the pointer to place where we pop the Rx byte
    ld c,(hl)                   ; get the Rx byte

    inc l                       ; move the Rx pointer low byte along
IF __IO_UART_RX_SIZE != 0x100
    ld a,__IO_UART_RX_SIZE-1    ; load the buffer size, (n^2)-1
    and l                       ; range check
    or uartbRxBuffer&0xFF       ; locate base
    ld l,a                      ; return the low byte to l
ENDIF
    ld (uartbRxOut),hl          ; write where the next byte should be popped

    ld hl,uartbRxCount
    dec (hl)                    ; atomically decrement Rx count

    ld l,c                      ; put the byte in hl
    ld a,c                      ; put byte in a
    scf                         ; indicate char received
    ret

EXTERN _uart_need
defc NEED = _uart_need

