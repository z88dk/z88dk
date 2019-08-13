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

    PUBLIC asm_i2c1_read_byte_set

    EXTERN __i2c1RxOutPtr, __i2c1RxBufUsed
    EXTERN __i2c1ControlEcho, __i2c1SlaveAddr, __i2c1SentenceLgth

    EXTERN pca9665_write_direct

;   Read from the I2C Interface, using Byte Mode transmission
;   int i2c_read_byte_mode( char addr, char *dp, char length );
;   parameters passed in registers
;   B  = length of data sentence expected, uint8_t _i2c1SentenceLgth
;   C  = address of slave device, uint8_t _i2c1SlaveAddr, Bit 0:[R=1,W=0]

.asm_i2c1_read_byte_set
    ld a,(__i2c1ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    ret Z                       ;return if the I2C interface is busy

    ld a,b                      ;check the sentence expected for zero
    and a
    ret Z                       ;return if the sentence is 0 length

    ld (__i2c1SentenceLgth),a   ;store the sentence length 

    ld a,c                      ;store the slave address
    set 0,a                     ;ensure we're reading Bit 0:[R=1]
    ld (__i2c1SlaveAddr),a

    ld a,__IO_I2C_CON_ENSIO
    ld (__i2c1ControlEcho),a    ;store enabled in the control echo    

    ld c,__IO_I2C1_PORT_MSB|__IO_I2C_PORT_CON
    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STA
    jp pca9665_write_direct     ;set the interface enable and STA bit

