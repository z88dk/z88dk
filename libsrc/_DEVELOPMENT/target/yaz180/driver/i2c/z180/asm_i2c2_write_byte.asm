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

    PUBLIC asm_i2c2_write_byte

    EXTERN __i2c2TxInPtr, __i2c2TxBufUsed
    EXTERN __i2c2ControlEcho, __i2c2SlaveAddr, __i2c2SentenceLgth

;   Write to the I2C Interface, using Byte Mode transmission
;   int i2c_write_byte_mode( char addr, char *dp, char length );
;   parameters passed in registers
;   HL = pointer to data to transmit, uint8_t *dp
;   B  = length of data sentence, uint8_t _i2c2SentenceLgth
;   C  = address of slave device, uint8_t _i2c2SlaveAddr, Bit 0:[R=1,W=0]

.asm_i2c2_write_byte
    ld a,(__i2c2ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    ret Z                       ;return if the I2C interface is busy

    ld a,b                      ;check the sentence provided for zero length
    and a
    ret Z                       ;return if the sentence is 0 length

    ld a,(__i2c2TxBufUsed)      ;check our ring buffer fullness
    add a,b
    ret C                       ;ring buffer would overflow, return
    ld (__i2c2TxBufUsed),a      ;store the new buffer fullness

    ld a,b                      ;store the sentence length 
    ld (__i2c2SentenceLgth),a  

    ld a,c                      ;store the slave address
    res 0,a                     ;ensure we're writing Bit 0:[W=0]
    ld (__i2c2SlaveAddr),a

    push de
    ex de,hl                    ;move the data pointer to de
    ld hl,(__i2c2TxInPtr)       ;get the ring buffer pointer address
.i2c2_write_byte2
    ld a,(de)                   ;copy input sentence
    ld (hl),a                   ;to the ring buffer
    inc de                      ;increment the input pointer
    inc l                       ;increment low byte of ring buffer
    djnz i2c2_write_byte2       ;repeat for the length of sentence

    ld (__i2c2TxInPtr),hl       ;store the final ring buffer pointer
    pop de

    ld a,__IO_I2C_CON_ENSIO
    ld (__i2c2ControlEcho),a    ;store enabled in the control echo

    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STA
    out (c),a                   ;set the interface enable and STA bit
    ret

