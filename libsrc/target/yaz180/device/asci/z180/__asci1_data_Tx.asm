
INCLUDE "config_private.inc"

SECTION data_driver

PUBLIC asci1TxCount, asci1TxIn, asci1TxOut, asci1TxLock

asci1TxCount:    defb 0                 ; Space for Tx Buffer Management
asci1TxIn:       defw asci1TxBuffer     ; non-zero item in bss since it's initialized anyway
asci1TxOut:      defw asci1TxBuffer     ; non-zero item in bss since it's initialized anyway
asci1TxLock:     defb $FE               ; lock flag for Tx exclusion

IF  __ASCI1_TX_SIZE = 256
    SECTION data_align_256
ENDIF
IF  __ASCI1_TX_SIZE = 128
    SECTION data_align_128
ENDIF
IF  __ASCI1_TX_SIZE = 64
    SECTION data_align_64
ENDIF
IF  __ASCI1_TX_SIZE = 32
    SECTION data_align_32
ENDIF
IF  __ASCI1_TX_SIZE = 16
    SECTION data_align_16
ENDIF
IF  __ASCI1_TX_SIZE = 8
    SECTION data_align_8
ENDIF
IF  __ASCI1_TX_SIZE%8 != 0
    ERROR "__ASCI1_TX_SIZE not 2^n"
ENDIF

PUBLIC asci1TxBuffer

asci1TxBuffer:   defs __ASCI1_TX_SIZE  ; Space for the Tx Buffer

; pad to next boundary

IF  __ASCI1_TX_SIZE = 256
    ALIGN   256
ENDIF
IF  __ASCI1_TX_SIZE = 128
    ALIGN   128
ENDIF
IF  __ASCI1_TX_SIZE = 64
    ALIGN   64
ENDIF
IF  __ASCI1_TX_SIZE = 32
    ALIGN   32
ENDIF
IF  __ASCI1_TX_SIZE = 16
    ALIGN   16
ENDIF
IF  __ASCI1_TX_SIZE = 8
    ALIGN   8
ENDIF

