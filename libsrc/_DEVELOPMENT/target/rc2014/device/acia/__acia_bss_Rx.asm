
SECTION bss_driver

PUBLIC aciaRxCount, aciaRxIn, aciaRxOut
 
aciaRxCount:    defb 0                  ; Space for Rx Buffer Management 
aciaRxIn:       defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
aciaRxOut:      defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway


SECTION bss_align_256

PUBLIC aciaRxBuffer

aciaRxBuffer:   defs $FF                ; Space for the Rx Buffer 
