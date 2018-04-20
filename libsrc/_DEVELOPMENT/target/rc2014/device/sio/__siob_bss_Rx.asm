
INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC siobRxCount, siobRxIn, siobRxOut, siobRxLock
 
siobRxCount:    defb 0                  ; Space for Rx Buffer Management 
siobRxIn:       defw siobRxBuffer       ; non-zero item in bss since it's initialized anyway
siobRxOut:      defw siobRxBuffer       ; non-zero item in bss since it's initialized anyway
siobRxLock:     defb 0                  ; lock flag for Rx exclusion

SECTION bss_align_256

; pad to next 256 byte boundary

ALIGN 0x100

PUBLIC siobRxBuffer

siobRxBuffer:   defs __IO_SIO_RX_SIZE   ; Space for the Rx Buffer

