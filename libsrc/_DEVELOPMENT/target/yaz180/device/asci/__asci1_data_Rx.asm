
INCLUDE "config_private.inc"
    
SECTION rodata_common1_data

PUBLIC asci1RxBuffer

asci1RxBuffer:   defs __ASCI1_RX_SIZE   ; Space for the Rx Buffer

; pad to next 256 byte boundary

IF (ASMPC & 0xff)
   defs 256 - (ASMPC & 0xff)
ENDIF

SECTION rodata_common1_data

PUBLIC asci1RxCount, asci1RxIn, asci1RxOut, asci1RxLock
 
asci1RxCount:    defb 0                 ; Space for Rx Buffer Management 
asci1RxIn:       defw asci1RxBuffer     ; non-zero item in bss since it's initialized anyway
asci1RxOut:      defw asci1RxBuffer     ; non-zero item in bss since it's initialized anyway
asci1RxLock:     defb $FE               ; lock flag for Rx exclusion

