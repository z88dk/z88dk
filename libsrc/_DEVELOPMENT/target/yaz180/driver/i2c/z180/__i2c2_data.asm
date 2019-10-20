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

    PUBLIC __i2c2RxPtr, __i2c2TxPtr
    PUBLIC __i2c2ControlEcho, __i2c2ControlInput, __i2c2SlaveAddr, __i2c2SentenceLgth

    __i2c2RxPtr:        DEFW    0
    __i2c2TxPtr:        DEFW    0

    __i2c2ControlEcho:  DEFB    0
    __i2c2ControlInput: DEFB    0
    __i2c2SlaveAddr:    DEFB    0
    __i2c2SentenceLgth: DEFB    0
