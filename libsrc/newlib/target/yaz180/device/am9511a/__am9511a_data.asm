
    INCLUDE "config_private.inc"

    SECTION data_align_256

    PUBLIC APUCMDBuf, APUPTRBuf

    APUCMDBuf:      DEFS    __APU_CMD_SIZE
    APUPTRBuf:      DEFS    __APU_PTR_SIZE

    ; pad to next 256 byte boundary

    ALIGN 256

    SECTION data_driver

    PUBLIC APUCMDInPtr, APUCMDOutPtr, APUPTRInPtr, APUPTROutPtr
    PUBLIC APUCMDBufUsed, APUPTRBufUsed, APUStatus, APUError, APULock

    APUCMDInPtr:    DEFW    APUCMDBuf
    APUCMDOutPtr:   DEFW    APUCMDBuf
    APUPTRInPtr:    DEFW    APUPTRBuf
    APUPTROutPtr:   DEFW    APUPTRBuf
    APUCMDBufUsed:  DEFB    0
    APUPTRBufUsed:  DEFB    0
    APUStatus:      DEFB    0
    APUError:       DEFB    0
    APULock:        DEFB    $FE
