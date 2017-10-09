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

    PUBLIC __i2c1_read_byte_get

    EXTERN __i2c1RxOutPtr, __i2c1RxBufUsed
    EXTERN __i2c1ControlEcho, __i2c1SlaveAddr, __i2c1SentenceLgth

    EXTERN pca9665_write_direct

;   Read from the I2C Interface, using Byte Mode transmission
;   parameters passed in registers
;   HL = pointer to receive buffer, uint8_t *dp
;   B  = length of data sentence expected, uint8_t _i2c1SentenceLgth
;   C  = address of slave device, uint8_t _i2c1SlaveAddr, Bit 0:[R=1,W=0]
;   L  = length of data received, uint8_t

__i2c1_read_byte_get:
    push de
    push af
    ex de, hl                   ;move the data pointer to de

    ld a, b                     ;check the sentence expected for zero
    and a
    jr Z, i2c1_read_byte_ex     ;return if the sentence is 0 length

    ld a, (__i2c1SentenceLgth)  ;check the expected sentence length
    cp b
    jr NZ, i2c1_read_byte_ex    ;return if the sentence length request is mismatched
    
    ld a, (__i2c1SlaveAddr)     ;check the slave address
    or $01                      ;ensure we're reading Bit 0:[R=1]
    cp c
    jr NZ, i2c1_read_byte_ex    ;return if the slave address is mismatched

i2c1_read_byte_wait:            ;busy wait loop
    ld a, (__i2c1ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    jr NZ, i2c1_read_byte_ex    ;just exit if a fault
      
    and __IO_I2C_CON_ECHO_BUS_STOPPED
    jr Z, i2c1_read_byte_wait   ;if the bus is still not stopped, then wait till it is

    ld a, (__i2c1RxBufUsed)     ;check our ring buffer fullness
    cp a, b
    jr C, i2c1_read_byte_ex     ;actual bytes less than the requested bytes
    sub a, b
    ld (__i2c1RxBufUsed), a     ;store the new buffer fullness

    ld hl, (__i2c1RxOutPtr)     ;get the ring buffer pointer address
i2c1_read_byte3:
    ld a, (hl)                  ;copy ring buffer
    ld (de), a                  ;to the output sentence buffer
    inc de                      ;increment the output buffer
    inc l                       ;increment the low byte of ring buffer pointer
    djnz i2c1_read_byte3        ;repeat for length of sentence
    
    ld (__i2c1RxOutPtr), hl     ;store the ring buffer pointer
    
    ld hl, __i2c1SentenceLgth   ;put the sentence length in l
    ld l, (hl)

i2c1_read_byte_ex:              ;return
    pop de
    pop af
    ret 

