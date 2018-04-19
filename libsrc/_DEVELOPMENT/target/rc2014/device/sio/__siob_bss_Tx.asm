
INCLUDE "config_private.inc"

SECTION bss_driver

PUBLIC siobTxCount, siobTxIn, siobTxOut, siobTxLock

siobTxCount:    defb 0                  ; Space for Tx Buffer Management
siobTxIn:       defw siobTxBuffer       ; non-zero item in bss since it's initialized anyway
siobTxOut:      defw siobTxBuffer       ; non-zero item in bss since it's initialized anyway
siobTxLock:     defb 0                  ; lock flag for Tx exclusion

PUBLIC siobTxBuffer

siobTxBuffer:   defs __IO_SIO_TX_SIZE   ; Space for the Tx Buffer

