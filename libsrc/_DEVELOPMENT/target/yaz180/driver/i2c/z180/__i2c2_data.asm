;==============================================================================
; Contents of this file are copyright Phillip Stevens
;
; You have permission to use this for NON COMMERCIAL USE ONLY
; If you wish to use it elsewhere, please include an acknowledgement to myself.
;
; https://github.com/feilipu/
;
; https://feilipu.me/
;
;
; This work was authored in Marrakech, Morocco during May/June 2017.

    INCLUDE "config_private.inc"

    SECTION data_align_256

    PUBLIC __i2c2RxBuffer, __i2c2TxBuffer

    ALIGN 0x0100

    __i2c2RxBuffer:   DEFS    __IO_I2C_RX_SIZE
    __i2c2TxBuffer:   DEFS    __IO_I2C_TX_SIZE

    SECTION data_driver

    PUBLIC __i2c2RxInPtr, __i2c2RxOutPtr, __i2c2RxBufUsed
    PUBLIC __i2c2TxInPtr, __i2c2TxOutPtr, __i2c2TxBufUsed
    PUBLIC __i2c2ControlEcho, __i2c2SlaveAddr, __i2c2SentenceLgth

    __i2c2RxInPtr:      DEFW    __i2c2RxBuffer
    __i2c2RxOutPtr:     DEFW    __i2c2RxBuffer
    __i2c2TxInPtr:      DEFW    __i2c2TxBuffer
    __i2c2TxOutPtr:     DEFW    __i2c2TxBuffer
    __i2c2RxBufUsed:    DEFB    0
    __i2c2TxBufUsed:    DEFB    0

    __i2c2ControlEcho:  DEFB    0
    __i2c2SlaveAddr:    DEFB    0
    __i2c2SentenceLgth: DEFB    0

