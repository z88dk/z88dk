
IF __CPU_INTEL__
INCLUDE "newlib/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION data_driver

PUBLIC uartaControl
PUBLIC uartaRxCount, uartaRxIn, uartaRxOut

uartaControl:   defb 0                  ; control flag
uartaRxCount:   defb 0                  ; Space for Rx Buffer Management 
uartaRxIn:      defw uartaRxBuffer      ; pointer to buffer
uartaRxOut:     defw uartaRxBuffer      ; pointer to buffer


IF  __IO_UART_RX_SIZE = 256
    SECTION data_align_256
    ALIGN   256
ENDIF
IF  __IO_UART_RX_SIZE = 128
    SECTION data_align_128
    ALIGN   128
ENDIF
IF  __IO_UART_RX_SIZE = 64
    SECTION data_align_64
    ALIGN   64
ENDIF
IF  __IO_UART_RX_SIZE = 32
    SECTION data_align_32
    ALIGN   32
ENDIF
IF  __IO_UART_RX_SIZE = 16
    SECTION data_align_16
    ALIGN   16
ENDIF
IF  __IO_UART_RX_SIZE = 8
    SECTION data_align_8
    ALIGN   8
ENDIF
IF  __IO_UART_RX_SIZE%8 != 0
    ERROR "__IO_UART_RX_SIZE not 2^n"
ENDIF

PUBLIC uartaRxBuffer

uartaRxBuffer:  defs    __IO_UART_RX_SIZE   ; Space for the Rx Buffer

; pad to next boundary

IF  __IO_UART_RX_SIZE = 256
    ALIGN   256
ENDIF
IF  __IO_UART_RX_SIZE = 128
    ALIGN   128
ENDIF
IF  __IO_UART_RX_SIZE = 64
    ALIGN   64
ENDIF
IF  __IO_UART_RX_SIZE = 32
    ALIGN   32
ENDIF
IF  __IO_UART_RX_SIZE = 16
    ALIGN   16
ENDIF
IF  __IO_UART_RX_SIZE = 8
    ALIGN   8
ENDIF

