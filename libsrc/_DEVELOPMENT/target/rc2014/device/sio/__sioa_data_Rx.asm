
INCLUDE "config_private.inc"

SECTION data_driver

PUBLIC sioaRxCount, sioaRxIn, sioaRxOut, sioaRxLock

sioaRxCount:    defb 0                  ; Space for Rx Buffer Management 
sioaRxIn:       defw sioaRxBuffer       ; non-zero item in data since it's initialized anyway
sioaRxOut:      defw sioaRxBuffer       ; non-zero item in data since it's initialized anyway
sioaRxLock:     defb 0                  ; lock flag for Rx exclusion

IF  __IO_SIO_RX_SIZE = 256
    SECTION data_align_256
ENDIF
IF  __IO_SIO_RX_SIZE = 128
    SECTION data_align_128
ENDIF
IF  __IO_SIO_RX_SIZE = 64
    SECTION data_align_64
ENDIF
IF  __IO_SIO_RX_SIZE = 32
    SECTION data_align_32
ENDIF
IF  __IO_SIO_RX_SIZE = 16
    SECTION data_align_16
ENDIF
IF  __IO_SIO_RX_SIZE = 8
    SECTION data_align_8
ENDIF
IF  __IO_SIO_RX_SIZE%8 != 0
    ERROR "__IO_SIO_RX_SIZE not 2^n"
ENDIF

PUBLIC sioaRxBuffer

sioaRxBuffer:   defs __IO_SIO_RX_SIZE   ; Space for the Rx Buffer

; pad to next boundary

IF  __IO_SIO_RX_SIZE = 256
    ALIGN   256
ENDIF
IF  __IO_SIO_RX_SIZE = 128
    ALIGN   128
ENDIF
IF  __IO_SIO_RX_SIZE = 64
    ALIGN   64
ENDIF
IF  __IO_SIO_RX_SIZE = 32
    ALIGN   32
ENDIF
IF  __IO_SIO_RX_SIZE = 16
    ALIGN   16
ENDIF
IF  __IO_SIO_RX_SIZE = 8
    ALIGN   8
ENDIF

