INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC aciaRxCount, aciaRxIn, aciaRxOut
 
aciaRxCount:    defb 0                  ; Space for Rx Buffer Management 
aciaRxIn:       defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
aciaRxOut:      defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway


SECTION data_align_256

PUBLIC aciaRxBuffer

aciaRxBuffer:   defs __IO_ACIA_RX_SIZE  ; Space for the Rx Buffer

; pad to next 256 byte boundary

IF (ASMPC & 0xff)
   defs 256 - (ASMPC & 0xff)
ENDIF
