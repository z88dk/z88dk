
INCLUDE "config_private.inc"

SECTION data_align_256

PUBLIC asci1TxBuffer

asci1TxBuffer:   defs __ASCI1_TX_SIZE  ; Space for the Tx Buffer

; pad to next 256 byte boundary

ALIGN 256

SECTION data_driver

PUBLIC asci1TxCount, asci1TxIn, asci1TxOut, asci1TxLock

asci1TxCount:    defb 0                 ; Space for Tx Buffer Management
asci1TxIn:       defw asci1TxBuffer     ; non-zero item in bss since it's initialized anyway
asci1TxOut:      defw asci1TxBuffer     ; non-zero item in bss since it's initialized anyway
asci1TxLock:     defb $FE               ; lock flag for Tx exclusion

