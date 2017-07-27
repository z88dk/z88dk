SECTION bss_driver

EXTERN __ASCI0_RX_SIZE

PUBLIC asci0RxCount, asci0RxIn, asci0RxOut
 
asci0RxCount:    defb 0                 ; Space for Rx Buffer Management 
asci0RxIn:       defw asci0RxBuffer     ; non-zero item in bss since it's initialized anyway
asci0RxOut:      defw asci0RxBuffer     ; non-zero item in bss since it's initialized anyway


SECTION data_align_256

PUBLIC asci0RxBuffer

asci0RxBuffer:   defs __ASCI0_RX_SIZE   ; Space for the Rx Buffer

; pad to next 256 byte boundary

IF (ASMPC & 0xff)
   defs 256 - (ASMPC & 0xff)
ENDIF
