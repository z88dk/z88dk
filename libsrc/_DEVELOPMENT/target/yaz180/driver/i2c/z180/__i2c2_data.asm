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

    SECTION bss_driver

    PUBLIC __i2c2RxInPtr, __i2c2RxOutPtr
    PUBLIC __i2c2TxInPtr, __i2c2TxOutPtr
    PUBLIC __i2c2ControlEcho, __i2c2SlaveAddr, __i2c2SentenceLgth

    __i2c2RxInPtr:      DEFW    0
    __i2c2RxOutPtr:     DEFW    0
    __i2c2TxInPtr:      DEFW    0
    __i2c2TxOutPtr:     DEFW    0

    __i2c2ControlEcho:  DEFB    0
    __i2c2SlaveAddr:    DEFB    0
    __i2c2SentenceLgth: DEFB    0

