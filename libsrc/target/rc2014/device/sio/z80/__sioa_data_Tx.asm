
INCLUDE "config_private.inc"

SECTION data_driver

PUBLIC sioaTxCount, sioaTxIn, sioaTxOut, sioaTxLock

sioaTxCount:    defb 0                  ; Space for Tx Buffer Management
sioaTxIn:       defw sioaTxBuffer       ; pointer to buffer
sioaTxOut:      defw sioaTxBuffer       ; pointer to buffer
sioaTxLock:     defb 0                  ; lock flag for Tx exclusion

IF  __IO_SIO_TX_SIZE = 256
    SECTION data_align_256
    ALIGN   256
ENDIF
IF  __IO_SIO_TX_SIZE = 128
    SECTION data_align_128
    ALIGN   128
ENDIF
IF  __IO_SIO_TX_SIZE = 64
    SECTION data_align_64
    ALIGN   64
ENDIF
IF  __IO_SIO_TX_SIZE = 32
    SECTION data_align_32
    ALIGN   32
ENDIF
IF  __IO_SIO_TX_SIZE = 16
    SECTION data_align_16
    ALIGN   16
ENDIF
IF  __IO_SIO_TX_SIZE = 8
    SECTION data_align_8
    ALIGN   8
ENDIF
IF  __IO_SIO_TX_SIZE%8 != 0
    ERROR "__IO_SIO_TX_SIZE not 2^n"
ENDIF

PUBLIC sioaTxBuffer

sioaTxBuffer:   defs __IO_SIO_TX_SIZE   ; Space for the Tx Buffer

; pad to next boundary

IF  __IO_SIO_TX_SIZE = 256
    ALIGN   256
ENDIF
IF  __IO_SIO_TX_SIZE = 128
    ALIGN   128
ENDIF
IF  __IO_SIO_TX_SIZE = 64
    ALIGN   64
ENDIF
IF  __IO_SIO_TX_SIZE = 32
    ALIGN   32
ENDIF
IF  __IO_SIO_TX_SIZE = 16
    ALIGN   16
ENDIF
IF  __IO_SIO_TX_SIZE = 8
    ALIGN   8
ENDIF

