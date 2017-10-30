
INCLUDE "config_private.inc"

;------------------------------------------------------------------------------
; start of definitions
;------------------------------------------------------------------------------

EXTERN  __register_sp

; start of the Transitory Program Area (TPA) Control Block for BANK1 through BANK12
; this area is Flash (essentially ROM) for BANK0, BANK13, BANK14, & BANK15, and
; can't be easily written
;
; TCB is from 0x003B through to 0x005B

PUBLIC  _bios_sp, _bank_sp

defc    _bios_sp    =   __register_sp   ; yabios SP here when other banks running
defc    _bank_sp    =   $003B           ; bank local SP storage, in Page0 TCB

;------------------------------------------------------------------------------
; start of common area 1 - page aligned data
;------------------------------------------------------------------------------

SECTION rodata_common1_data

PHASE   __COMMON_AREA_1_PHASE_DATA

PUBLIC APUCMDBuf, APUDATABuf

APUCMDBuf:      defs    __APU_CMD_SIZE
APUDATABuf:     defs    __APU_DATA_SIZE

PUBLIC asci0RxBuffer, asci0TxBuffer

asci0RxBuffer:  defs    __ASCI0_RX_SIZE ; Space for the Rx0 Buffer
asci0TxBuffer:  defs    __ASCI0_TX_SIZE ; Space for the Tx0 Buffer

PUBLIC asci1RxBuffer, asci1TxBuffer

asci1RxBuffer:  defs    __ASCI1_RX_SIZE ; Space for the Rx1 Buffer
asci1TxBuffer:  defs    __ASCI1_TX_SIZE ; Space for the Tx1 Buffer

; optionally, pad to next 256 byte boundary

IF (ASMPC & 0xff)
   defs 256 - (ASMPC & 0xff)
ENDIF

;------------------------------------------------------------------------------
; start of common area 1 - non aligned data
;------------------------------------------------------------------------------

; immediately after page aligned area so that we don't have to worry about the
; LSB when indexing, for far_call, far_jp, and system_rst

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

PUBLIC APUCMDInPtr, APUCMDOutPtr, APUDATAInPtr, APUDATAOutPtr
PUBLIC APUCMDBufUsed, APUDATABufUsed, APUStatus, APUError, _APULock

APUCMDInPtr:    defw    APUCMDBuf
APUCMDOutPtr:   defw    APUCMDBuf
APUDATAInPtr:   defw    APUDATABuf
APUDATAOutPtr:  defw    APUDATABuf
APUCMDBufUsed:  defb    0
APUDATABufUsed: defb    0
APUStatus:      defb    0
APUError:       defb    0
_APULock:       defb    $FE             ; mutex for APU

PUBLIC asci0RxCount, asci0RxIn, asci0RxOut, _asci0RxLock

asci0RxCount:   defb    0               ; Space for Rx Buffer Management 
asci0RxIn:      defw    asci0RxBuffer   ; non-zero item since it's initialized anyway
asci0RxOut:     defw    asci0RxBuffer   ; non-zero item since it's initialized anyway
_asci0RxLock:   defb    $FE             ; mutex for Rx0

PUBLIC asci0TxCount, asci0TxIn, asci0TxOut, _asci0TxLock

asci0TxCount:   defb    0               ; Space for Tx Buffer Management
asci0TxIn:      defw    asci0TxBuffer   ; non-zero item since it's initialized anyway
asci0TxOut:     defw    asci0TxBuffer   ; non-zero item since it's initialized anyway
_asci0TxLock:   defb    $FE             ; mutex for Tx0

PUBLIC asci1RxCount, asci1RxIn, asci1RxOut, _asci1RxLock
 
asci1RxCount:   defb    0               ; Space for Rx Buffer Management 
asci1RxIn:      defw    asci1RxBuffer   ; non-zero item since it's initialized anyway
asci1RxOut:     defw    asci1RxBuffer   ; non-zero item since it's initialized anyway
_asci1RxLock:   defb    $FE             ; mutex for Rx1

PUBLIC asci1TxCount, asci1TxIn, asci1TxOut, _asci1TxLock

asci1TxCount:   defb    0               ; Space for Tx Buffer Management
asci1TxIn:      defw    asci1TxBuffer   ; non-zero item since it's initialized anyway
asci1TxOut:     defw    asci1TxBuffer   ; non-zero item since it's initialized anyway
_asci1TxLock:   defb    $FE             ; mutex for Tx1

DEPHASE
