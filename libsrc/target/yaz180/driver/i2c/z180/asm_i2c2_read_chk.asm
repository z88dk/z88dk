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

    SECTION code_driver

    PUBLIC asm_i2c2_read_chk

    EXTERN __i2c2RxPtr
    EXTERN __i2c2ControlEcho, __i2c2SlaveAddr, __i2c2SentenceLgth

    EXTERN pca9665_read_burst

;   Read from the I2C Interface, using Byte Mode transmission
;   uint8_t i2c_read_chk( char addr, char length );
;   parameters passed in registers
;   B  = length of data sentence expected, uint8_t _i2c2SentenceLgth
;   C  = 7 bit address of slave device, uint8_t _i2c2SlaveAddr

.asm_i2c2_read_chk
    ld hl,0                     ;prepare zero return

    ld a,(__i2c2SlaveAddr)      ;check the 7 bit slave address
    rra
    xor c
    ret NZ                      ;return if the slave address is mismatched

    ld a,b                      ;check the sentence expected for zero length
    and a
    ret Z                       ;return if the expected sentence is 0 length

    ld a,(__i2c2ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    ret Z                       ;if the bus is still not stopped

    ld a,b                      ;check we have the bytes we require
    ld hl,__i2c2SentenceLgth
    sub a,(hl)                  ;subtract the remaining unobtained sentence length

    ld h,0
    ld l,a                      ;capture the number of available bytes
    ret

