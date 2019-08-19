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

    PUBLIC asm_i2c1_write_byte

    EXTERN __i2c1TxPtr
    EXTERN __i2c1ControlEcho, __i2c1SlaveAddr, __i2c1SentenceLgth

;   Write to the I2C Interface, using Byte Mode transmission
;   uint8_t i2c_write_byte( char addr, char *dp, char length );
;   parameters passed in registers
;   HL = pointer to data to transmit, uint8_t *dp
;   B  = length of data sentence, uint8_t _i2c1SentenceLgth
;   C  = address of slave device, uint8_t _i2c1SlaveAddr, Bit 0:[R=1,W=0]

.asm_i2c1_write_byte
    ld a,(__i2c1ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    ret Z                       ;return if the I2C interface is busy

    ld a,b
    or a                        ;check the sentence provided for zero length
    ret Z                       ;return if the sentence is 0 length

    ld (__i2c1SentenceLgth),a   ;store the sentence length

    ld a,c                      ;store the slave address
    res 0,a                     ;ensure we're writing Bit 0:[W=0]
    ld (__i2c1SlaveAddr),a

    ld (__i2c1TxPtr),hl         ;store the buffer pointer

    ld a,__IO_I2C_CON_ENSIO
    ld (__i2c1ControlEcho),a    ;store enabled in the control echo

    ld bc,__IO_I2C1_PORT_BASE|__IO_I2C_PORT_CON
    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STA
    out (c),a                   ;set the interface enable and STA bit
    ret

