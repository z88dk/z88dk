
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

EXTERN _uarta_flush_rx, _uartb_flush_rx
EXTERN uartaControl, uartbControl

PUBLIC _uart_init

._uart_init
    ; initialise the UART(s)

    ; confirm UART A exists by checking the UART divisor latch & scratch registers
    xor a
    out (__IO_UARTA_IER_REGISTER),a         ; clear any enabled interrupts

    ld a,__IO_UART_LCR_DLAB                 ; DLAB enable bit
    out (__IO_UARTA_LCR_REGISTER),a         ; output to LCR

    ld a,$a5                                ; load a test byte
    out (__IO_UARTA_DLM_REGISTER),a         ; write it to UART A DLM register
    in a,(__IO_UARTA_DLM_REGISTER)          ; read it back

    rrca
    out (__IO_UARTA_SCRATCH_REGISTER),a     ; write it to UART A SCRATCH register
    in a,(__IO_UARTA_SCRATCH_REGISTER)      ; read it back

    rlca
    cp $a5
    jp NZ,uart_enable_b                     ; doesn't exist, try UART B

    ; set the divisor latch preferred baud
    ld a,__IO_UART_DLL_115200               ; default to 115200 baud
    out (__IO_UARTA_DLL_REGISTER),a         ; divisor LSB
    xor a
    out (__IO_UARTA_DLM_REGISTER),a         ; divisor MSB

    ; reset divisor latch bit DLAB
    ; set word length, parity, and stop bits
    ld a,__IO_UART_LCR_STOP|__IO_UART_LCR_8BIT  ; default to 8n2
    out (__IO_UARTA_LCR_REGISTER),a             ; output to LCR

    ; enable and reset the FIFOs
    ld a,__IO_UART_FCR_FIFO_08|__IO_UART_FCR_FIFO_TX_RESET|__IO_UART_FCR_FIFO_RX_RESET|__IO_UART_FCR_FIFO_ENABLE
    out (__IO_UARTA_FCR_REGISTER),a

    ; set up modem control register to enable auto flow control, interrupt line, and RTS
    ld a,__IO_UART_MCR_AUTO_FLOW_CONTROL|__IO_UART_MCR_INT_ENABLE|__IO_UART_MCR_RTS|__IO_UART_MCR_DTR
    out (__IO_UARTA_MCR_REGISTER),a

    call _uarta_flush_rx                    ; clear the software receive buffer

    ; enable the receive interrupt (only)   XXX To do handle line errors
    ld a,__IO_UART_IER_ERBI
    out (__IO_UARTA_IER_REGISTER),a

    ; set the control flag, to signal that this channel exists
    ld a,__IO_UARTA_DATA_REGISTER
    ld (uartaControl),a

    ; now do UART B

.uart_enable_b

    ; confirm UART B exists by checking the UART divisor latch & scratch registers
    xor a
    out (__IO_UARTB_IER_REGISTER),a         ; clear any enabled interrupts

    ld a,__IO_UART_LCR_DLAB                 ; DLAB enable bit
    out (__IO_UARTB_LCR_REGISTER),a         ; output to LCR

    ld a,$a5                                ; load a test byte
    out (__IO_UARTB_DLM_REGISTER),a         ; write it to UART B DLM register
    in a,(__IO_UARTB_DLM_REGISTER)          ; read it back

    rrca
    out (__IO_UARTB_SCRATCH_REGISTER),a     ; write it to UART B SCRATCH register
    in a,(__IO_UARTB_SCRATCH_REGISTER)      ; read it back

    rlca
    cp $a5
    ret NZ                                  ; doesn't exist, just return

    ; set the divisor latch preferred baud
    ld a,__IO_UART_DLL_115200               ; default to 115200 baud
    out (__IO_UARTB_DLL_REGISTER),a         ; divisor LSB
    xor a
    out (__IO_UARTB_DLM_REGISTER),a         ; divisor MSB

    ; reset divisor latch bit DLAB
    ; set word length, parity, and stop bits
    ld a,__IO_UART_LCR_STOP|__IO_UART_LCR_8BIT  ; default to 8n2
    out (__IO_UARTB_LCR_REGISTER),a             ; output to LCR

    ; enable and reset the FIFOs
    ld a,__IO_UART_FCR_FIFO_08|__IO_UART_FCR_FIFO_TX_RESET|__IO_UART_FCR_FIFO_RX_RESET|__IO_UART_FCR_FIFO_ENABLE
    out (__IO_UARTB_FCR_REGISTER),a

    ; set up modem control register to enable auto flow control, interrupt line, and RTS
    ld a,__IO_UART_MCR_AUTO_FLOW_CONTROL|__IO_UART_MCR_INT_ENABLE|__IO_UART_MCR_RTS|__IO_UART_MCR_DTR
    out (__IO_UARTB_MCR_REGISTER),a

    call _uartb_flush_rx                    ; clear the software receive buffer 

    ; enable the receive interrupt (only)   XXX To do handle line errors
    ld a,__IO_UART_IER_ERBI
    out (__IO_UARTB_IER_REGISTER),a

    ; set the control flag, to signal that this channel exists
    ld a,__IO_UARTB_DATA_REGISTER
    ld (uartbControl),a

    ret

EXTERN _uart_need
defc NEED = _uart_need
