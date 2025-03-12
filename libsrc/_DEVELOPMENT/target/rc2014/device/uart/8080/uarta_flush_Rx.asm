
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver
SECTION code_driver_character_input

PUBLIC _uarta_flush_rx_di
PUBLIC _uarta_flush_rx

EXTERN asm_cpu_push_di, asm_cpu_pop_ei
EXTERN uartaRxCount, uartaRxBuffer, uartaRxIn, uartaRxOut

._uarta_flush_rx_di

    push af
    push hl

    call asm_cpu_push_di        ; di

    call _uarta_flush_rx

    call asm_cpu_pop_ei         ; ei

    pop hl
    pop af

    ret

._uarta_flush_rx

    ; enable and reset the Rx FIFO
    ld a,__IO_UART_FCR_FIFO_08|__IO_UART_FCR_FIFO_RX_RESET|__IO_UART_FCR_FIFO_ENABLE
    out (__IO_UARTA_FCR_REGISTER),a

    xor a
    ld (uartaRxCount),a          ; reset the Rx counter (set 0)

    ld hl,uartaRxBuffer          ; load Rx buffer pointer home
    ld (uartaRxIn),hl
    ld (uartaRxOut),hl

    ret

EXTERN _uart_need
defc NEED = _uart_need

