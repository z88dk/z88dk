SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_write_byte, asm_i2c2_write_byte

PUBLIC i2c_write_byte_callee

;------------------------------------------------------------------------------
;   Write to the I2C Interface, using Byte Mode transmission
;
;   extern void __LIB__ i2c_write_byte_callee(uint8_t device,uint8_t addr,uint8_t *dp,uint8_t length) __smallc __z88dk_callee;
;
;   parameters passed in registers to asm functions
;   HL = pointer to data to transmit, uint8_t *dp
;   B  = length of data sentence, uint8_t length
;   C  = 7 bit address of slave device, uint8_t addr


.i2c_write_byte_callee
    pop af                              ;ret
    pop de                              ;length
    pop hl                              ;*dp
    pop bc                              ;slave address
    ld b,e                              ;length
    pop de                              ;device
    push af                             ;ret

    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_write_byte
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_write_byte
    ret                                 ;no device address match, so exit

