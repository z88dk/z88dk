
INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC sioaTxCount, sioaTxIn, sioaTxOut, sioaTxLock

sioaTxCount:    defb 0                  ; Space for Tx Buffer Management
sioaTxIn:       defw sioaTxBuffer       ; non-zero item in bss since it's initialized anyway
sioaTxOut:      defw sioaTxBuffer       ; non-zero item in bss since it's initialized anyway
sioaTxLock:     defb $FE                ; lock flag for Tx exclusion

PUBLIC sioaTxBuffer

sioaTxBuffer:   defs __IO_SIO_TX_SIZE   ; Space for the Tx Buffer

