
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_output

PUBLIC _uarta_flush_tx_di
PUBLIC _uarta_flush_tx

._uarta_flush_tx_di

    push af

    call _uarta_flush_tx

    pop af
    ret

._uarta_flush_tx

    ; enable and reset the Tx FIFO
    ld a,__IO_UART_FCR_FIFO_04|__IO_UART_FCR_FIFO_TX_RESET|__IO_UART_FCR_FIFO_ENABLE
    out (__IO_UARTA_FCR_REGISTER),a

    ret

EXTERN _uart_need
defc NEED = _uart_need

