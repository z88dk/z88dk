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

    PUBLIC asm_i2c2_read_byte_get

    EXTERN __i2c2RxPtr
    EXTERN __i2c2ControlEcho, __i2c2SlaveAddr, __i2c2SentenceLgth

;   Read from the I2C Interface, using Byte Mode transmission
;   uint8_t i2c_read_byte_get( char addr, char length );
;   parameters passed in registers
;   B  = length of data sentence expected, uint8_t _i2c2SentenceLgth
;   C  = address of slave device, uint8_t _i2c2SlaveAddr, Bit 0:[R=1,W=0]

.asm_i2c2_read_byte_get
    ld a,b                      ;check the sentence expected for zero
    and a
    ret Z                       ;return if the expected sentence is 0 length

    ld a,(__i2c2SlaveAddr)      ;check the slave address
    cp c
    ret NZ                      ;return if the slave address is mismatched

.i2c2_read_byte_wait            ;busy wait loop
    ld a,(__i2c2ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    jr Z,i2c2_read_byte_wait    ;if the bus is still not stopped, then wait till it is

    ret

