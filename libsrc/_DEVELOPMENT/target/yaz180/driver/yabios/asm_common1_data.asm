
INCLUDE "config_private.inc"

;------------------------------------------------------------------------------
; start of definitions
;------------------------------------------------------------------------------

PUBLIC  _bios_sp

IF __register_sp
EXTERN  __register_sp
defc    _bios_sp    =   __register_sp   ; yabios BANK0 SP here, when other banks running
ELSE
defc    _bios_sp    =   $FFDE           ; or here if __register_sp is undefined
ENDIF

; start of the Transitory Program Area (TPA) Control Block (TCB)
; for BANK1 through BANK12
; this area is Flash (essentially ROM) for BANK0, BANK13, BANK14, & BANK15,
; and can't be easily written to
;
; TCB is from 0x003B through to 0x005B (scratch space for CP/M)

PUBLIC  _bank_sp                        ; DEFW at 0x003B in Page 0

defc    _bank_sp    =   $003B

;------------------------------------------------------------------------------
; start of common area 1 - page aligned data
;------------------------------------------------------------------------------

SECTION rodata_common1_data

PHASE   __COMMON_AREA_1_PHASE_DATA

PUBLIC APUCMDBuf, APUDataBuf

APUCMDBuf:      defs    __APU_CMD_SIZE
APUDataBuf:     defs    __APU_DATA_SIZE

PUBLIC asci0RxBuffer, asci1RxBuffer

asci0RxBuffer:  defs    __ASCI0_RX_SIZE ; Space for the Rx0 Buffer
asci1RxBuffer:  defs    __ASCI1_RX_SIZE ; Space for the Rx1 Buffer

PUBLIC asciTxBuffer

asciTxBuffer:   defs    __ASCI0_TX_SIZE+__ASCI1_TX_SIZE ; Space for the Tx0 & Tx1 Buffer

; optionally, pad to next 256 byte boundary

IF (ASMPC & 0xff)
   defs 256 - (ASMPC & 0xff)
ENDIF

;------------------------------------------------------------------------------
; start of common area 1 - non aligned data
;------------------------------------------------------------------------------

; immediately after page aligned area so that we don't have to worry about the
; LSB when indexing, for call_far, jp_far, and system_rst

PUBLIC _bankLockBase

_bankLockBase:  defs    $10, $00        ; base address for 16 BANK locks
                                        ; $00 = BANK cold (uninitialised)
                                        ; $FE = BANK available to be entered
                                        ; $FF = BANK locked (active thread)

PUBLIC _shadowLock, _prt0Lock, _prt1Lock, _dmac0Lock, _dmac1Lock, _csioLock

_shadowLock:    defb    $FE             ; mutex for alternate registers
_prt0Lock:      defb    $FE             ; mutex for PRT0 
_prt1Lock:      defb    $FE             ; mutex for PRT1
_dmac0Lock:     defb    $FE             ; mutex for DMAC0
_dmac1Lock:     defb    $FE             ; mutex for DMAC1
_csioLock:      defb    $FE             ; mutex for CSI/O

PUBLIC __system_time_fraction, __system_time

__system_time_fraction: defb    0       ; uint8_t (1/256) fractional time
__system_time:          defs    4       ; uint32_t time_t

PUBLIC APUCMDInPtr, APUCMDOutPtr
PUBLIC APUDataEntInPtr, APUDataEntOutPtr
PUBLIC APUDataRemInPtr, APUDataRemOutPtr
PUBLIC APUCMDBufUsed, APUDataEntBufUsed, APUDataRemBufUsed
PUBLIC APUStatus, APUError, _APULock

APUCMDInPtr:            defw    APUCMDBuf
APUCMDOutPtr:           defw    APUCMDBuf
APUDataEntInPtr:        defw    APUDataBuf      ; even bytes are to load
APUDataEntOutPtr:       defw    APUDataBuf
APUDataRemInPtr:        defw    APUDataBuf+1    ; interleaved odd bytes to unload
APUDataRemOutPtr:       defw    APUDataBuf+1
APUCMDBufUsed:          defb    0
APUDataEntBufUsed:      defb    0
APUDataRemBufUsed:      defb    0
APUStatus:              defb    0
APUError:               defb    0
_APULock:               defb    $FE             ; mutex for APU

; currently active console interface, only bit 0 is distinguished currently with TTY=0 CRT=1.
PUBLIC  _bios_ioByte

_bios_ioByte:   defb    0               ; intel I/O byte

PUBLIC asci0RxCount, asci0RxIn, asci0RxOut, _asci0RxLock

asci0RxCount:   defb    0               ; Space for Rx Buffer Management 
asci0RxIn:      defw    asci0RxBuffer   ; non-zero item since it's initialized anyway
asci0RxOut:     defw    asci0RxBuffer   ; non-zero item since it's initialized anyway
_asci0RxLock:   defb    $FE             ; mutex for Rx0

PUBLIC asci0TxCount, asci0TxIn, asci0TxOut, _asci0TxLock

asci0TxCount:   defb    0               ; Space for Tx Buffer Management
asci0TxIn:      defw    asciTxBuffer    ; non-zero item since it's initialized anyway
asci0TxOut:     defw    asciTxBuffer    ; non-zero item since it's initialized anyway
_asci0TxLock:   defb    $FE             ; mutex for Tx0

PUBLIC asci1RxCount, asci1RxIn, asci1RxOut, _asci1RxLock
 
asci1RxCount:   defb    0               ; Space for Rx Buffer Management 
asci1RxIn:      defw    asci1RxBuffer   ; non-zero item since it's initialized anyway
asci1RxOut:     defw    asci1RxBuffer   ; non-zero item since it's initialized anyway
_asci1RxLock:   defb    $FE             ; mutex for Rx1

PUBLIC asci1TxCount, asci1TxIn, asci1TxOut, _asci1TxLock

asci1TxCount:   defb    0               ; Space for Tx Buffer Management
asci1TxIn:      defw    asciTxBuffer+1  ; non-zero item since it's initialized anyway
asci1TxOut:     defw    asciTxBuffer+1  ; non-zero item since it's initialized anyway
_asci1TxLock:   defb    $FE             ; mutex for Tx1

PUBLIC ideStatus, _ideLock

; IDE Status byte
; set bit 0 : User selects master (0) or slave (1) drive
; bit 1 : Flag 0 = master not previously accessed 
; bit 2 : Flag 0 = slave not previously accessed
ideStatus:      defb    0
_ideLock:       defb    $FE             ; mutex for IDE drive

PUBLIC initString, invalidTypeStr, badCheckSumStr, LoadOKStr

initString:     defm    CHAR_CR,CHAR_LF,"LoadHex::",0
invalidTypeStr: defm    CHAR_CR,CHAR_LF,"Invalid Type",CHAR_CR,CHAR_LF,0
badCheckSumStr: defm    CHAR_CR,CHAR_LF,"Checksum Error",CHAR_CR,CHAR_LF,0
LoadOKStr:      defm    CHAR_CR,CHAR_LF,"Done",CHAR_CR,CHAR_LF,0

DEPHASE
