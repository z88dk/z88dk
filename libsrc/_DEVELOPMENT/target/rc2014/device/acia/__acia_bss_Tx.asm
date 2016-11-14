
SECTION bss_driver

PUBLIC aciaTxBuffer
PUBLIC aciaTxCount, aciaTxIn, aciaTxOut, aciaTxLock

EXTERN ACIA_TX_SIZE

aciaTxBuffer:   defs $80  ;;ACIA_TX_SIZE       ; Space for the Tx Buffer
aciaTxCount:    defb 0                  ; Space for Tx Buffer Management
aciaTxIn:       defw aciaTxBuffer       ; non-zero item in bss since it's initialized anyway
aciaTxOut:      defw aciaTxBuffer       ; non-zero item in bss since it's initialized anyway
aciaTxLock:     defb 0                  ; lock flag for Tx exclusion
