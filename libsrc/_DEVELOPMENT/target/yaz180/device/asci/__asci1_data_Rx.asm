
INCLUDE "config_private.inc"

SECTION data_driver

PUBLIC asci1RxCount, asci1RxIn, asci1RxOut, asci1RxLock
 
asci1RxCount:    defb 0                 ; Space for Rx Buffer Management 
asci1RxIn:       defw asci1RxBuffer     ; non-zero item in bss since it's initialized anyway
asci1RxOut:      defw asci1RxBuffer     ; non-zero item in bss since it's initialized anyway
asci1RxLock:     defb $FE               ; lock flag for Rx exclusion

IF  __ASCI1_RX_SIZE = 256
    SECTION data_align_256
ENDIF
IF  __ASCI1_RX_SIZE = 128
    SECTION data_align_128
ENDIF
IF  __ASCI1_RX_SIZE = 64
    SECTION data_align_64
ENDIF
IF  __ASCI1_RX_SIZE = 32
    SECTION data_align_32
ENDIF
IF  __ASCI1_RX_SIZE = 16
    SECTION data_align_16
ENDIF
IF  __ASCI1_RX_SIZE = 8
    SECTION data_align_8
ENDIF
IF  __ASCI1_RX_SIZE%8 != 0
    ERROR "__ASCI1_RX_SIZE not 2^n"
ENDIF

PUBLIC asci1RxBuffer

asci1RxBuffer:   defs __ASCI1_RX_SIZE   ; Space for the Rx Buffer

; pad to next boundary

IF  __ASCI1_RX_SIZE = 256
    ALIGN   256
ENDIF
IF  __ASCI1_RX_SIZE = 128
    ALIGN   128
ENDIF
IF  __ASCI1_RX_SIZE = 64
    ALIGN   64
ENDIF
IF  __ASCI1_RX_SIZE = 32
    ALIGN   32
ENDIF
IF  __ASCI1_RX_SIZE = 16
    ALIGN   16
ENDIF
IF  __ASCI1_RX_SIZE = 8
    ALIGN   8
ENDIF

