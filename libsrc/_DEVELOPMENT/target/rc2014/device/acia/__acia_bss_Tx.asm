INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC aciaTxCount, aciaTxIn, aciaTxOut, aciaTxLock

aciaTxCount:    defb 0                  ; Space for Tx Buffer Management
aciaTxIn:       defw aciaTxBuffer       ; non-zero item in bss since it's initialized anyway
aciaTxOut:      defw aciaTxBuffer       ; non-zero item in bss since it's initialized anyway
aciaTxLock:     defb 0                  ; lock flag for Tx exclusion

PUBLIC aciaTxBuffer

aciaTxBuffer:   defs __IO_ACIA_TX_SIZE  ; Space for the Tx Buffer
