
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_output

PUBLIC _uarta_flush_Tx_di
PUBLIC _uarta_flush_Tx

EXTERN asm_cpu_push_di, asm_cpu_pop_ei

._uarta_flush_Tx_di

    push af
    push hl

    call asm_cpu_push_di        ; di

    call _uarta_flush_Tx

    call asm_cpu_pop_ei         ; ei

    pop hl
    pop af

    ret

._uarta_flush_Tx

    ; enable and reset the Tx FIFO
    ld a,__IO_UART_FCR_FIFO_14|__IO_UART_FCR_FIFO_TX_RESET|__IO_UART_FCR_FIFO_ENABLE
    out (__IO_UARTA_FCR_REGISTER),a

    ret

EXTERN _uart_need
defc NEED = _uart_need

