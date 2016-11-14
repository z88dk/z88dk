
SECTION bss_driver

PUBLIC aciaRxBuffer
PUBLIC aciaRxCount, aciaRxIn, aciaRxOut

EXTERN ACIA_RX_SIZE

aciaRxBuffer:   defs $80  ;;ACIA_RX_SIZE       ; Space for the Rx Buffer   
aciaRxCount:    defb 0                  ; Space for Rx Buffer Management 
aciaRxIn:       defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
aciaRxOut:      defw aciaRxBuffer       ; non-zero item in bss since it's initialized anyway
