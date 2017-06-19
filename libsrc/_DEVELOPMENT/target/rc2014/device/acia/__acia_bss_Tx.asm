
SECTION bss_driver

PUBLIC aciaTxCount, aciaTxIn, aciaTxOut, aciaTxLock

aciaTxCount:    defb 0                  ; Space for Tx Buffer Management
aciaTxIn:       defw aciaTxBuffer       ; non-zero item in bss since it's initialized anyway
aciaTxOut:      defw aciaTxBuffer       ; non-zero item in bss since it's initialized anyway
aciaTxLock:     defb 0                  ; lock flag for Tx exclusion

SECTION bss_align_256

PUBLIC aciaTxBuffer

aciaTxBuffer:   defs $0F                ; Space for the Tx Buffer
