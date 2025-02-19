
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_output

PUBLIC _uartb_flush_Tx_di
PUBLIC _uartb_flush_Tx

._uartb_flush_Tx_di

    push af

    call _uartb_flush_Tx

    pop af
    ret

._uartb_flush_Tx

    ; enable and reset the Tx FIFO
    ld a,__IO_UART_FCR_FIFO_04|__IO_UART_FCR_FIFO_TX_RESET|__IO_UART_FCR_FIFO_ENABLE
    out (__IO_UARTB_FCR_REGISTER),a

    ret

EXTERN _uart_need
defc NEED = _uart_need

