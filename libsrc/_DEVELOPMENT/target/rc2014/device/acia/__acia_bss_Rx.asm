INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC aciaRxCount, aciaRxIn, aciaRxOut
 
aciaRxCount:    defb 0                  ; Space for Rx Buffer Management 
aciaRxIn:       defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
aciaRxOut:      defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway


SECTION bss_align_256

PUBLIC aciaRxBuffer

aciaRxBuffer:   defs ACIA_RX_SIZE       ; Space for the Rx Buffer
                defs 256 - ASMPC
