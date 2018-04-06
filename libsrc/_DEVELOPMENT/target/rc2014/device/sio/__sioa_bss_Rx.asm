
INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC sioaRxCount, sioaRxIn, sioaRxOut, sioaRxLock
 
sioaRxCount:    defb 0                  ; Space for Rx Buffer Management 
sioaRxIn:       defw sioaRxBuffer       ; non-zero item in bss since it's initialized anyway
sioaRxOut:      defw sioaRxBuffer       ; non-zero item in bss since it's initialized anyway
sioaRxLock:     defb $FE                ; lock flag for Rx exclusion
    
SECTION bss_align_256

; pad to next 256 byte boundary

ALIGN 0x100

PUBLIC sioaRxBuffer

sioaRxBuffer:   defs __IO_SIO_RX_SIZE   ; Space for the Rx Buffer

