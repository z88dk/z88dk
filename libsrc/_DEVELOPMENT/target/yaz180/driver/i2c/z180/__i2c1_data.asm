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

    PUBLIC __i2c1RxBuffer, __i2c1TxBuffer
    
    ALIGN 0x0100

    __i2c1RxBuffer:   DEFS    __IO_I2C_RX_SIZE
    __i2c1TxBuffer:   DEFS    __IO_I2C_TX_SIZE 

    SECTION data_driver

    PUBLIC __i2c1RxInPtr, __i2c1RxOutPtr, __i2c1RxBufUsed
    PUBLIC __i2c1TxInPtr, __i2c1TxOutPtr, __i2c1TxBufUsed
    PUBLIC __i2c1ControlEcho, __i2c1SlaveAddr, __i2c1SentenceLgth
    
    __i2c1RxInPtr:      DEFW    __i2c1RxBuffer
    __i2c1RxOutPtr:     DEFW    __i2c1RxBuffer
    __i2c1TxInPtr:      DEFW    __i2c1TxBuffer
    __i2c1TxOutPtr:     DEFW    __i2c1TxBuffer
    __i2c1RxBufUsed:    DEFB    0
    __i2c1TxBufUsed:    DEFB    0

    __i2c1ControlEcho:  DEFB    0
    __i2c1SlaveAddr:    DEFB    0
    __i2c1SentenceLgth: DEFB    0

