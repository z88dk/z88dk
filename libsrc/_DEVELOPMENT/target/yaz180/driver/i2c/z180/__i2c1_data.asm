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

    PUBLIC __i2c1RxPtr, __i2c1TxPtr
    PUBLIC __i2c1ControlEcho, __i2c1ControlInput, __i2c1SlaveAddr, __i2c1SentenceLgth
    
    __i2c1RxPtr:        DEFW    0
    __i2c1TxPtr:        DEFW    0

    __i2c1ControlEcho:  DEFB    0
    __i2c1ControlInput: DEFB    0
    __i2c1SlaveAddr:    DEFB    0
    __i2c1SentenceLgth: DEFB    0

