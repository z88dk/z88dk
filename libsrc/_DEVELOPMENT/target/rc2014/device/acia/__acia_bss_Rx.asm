INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC aciaRxCount, aciaRxIn, aciaRxOut, aciaRxLock
 
aciaRxCount:    defb 0                  ; Space for Rx Buffer Management 
aciaRxIn:       defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
aciaRxOut:      defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
aciaRxLock:     defb 0                  ; lock flag for Rx exclusion

SECTION bss_align_256

; pad to next __IO_ACIA_RX_SIZE byte boundary

ALIGN __IO_ACIA_RX_SIZE

PUBLIC aciaRxBuffer

aciaRxBuffer:   defs __IO_ACIA_RX_SIZE  ; Space for the Rx Buffer

