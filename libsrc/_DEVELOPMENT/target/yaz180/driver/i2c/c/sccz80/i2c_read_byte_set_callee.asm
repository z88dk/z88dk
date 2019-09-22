SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_read_byte_set, asm_i2c2_read_byte_set

PUBLIC i2c_read_byte_set_callee

;------------------------------------------------------------------------------
;   Read from the I2C Interface, using Byte Mode transmission
;
;   extern void __LIB__ i2c_read_byte_set_callee(uint8_t device,uint8_t addr,uint8_t *dp,uint8_t length) __smallc __z88dk_callee;
;
;   parameters passed in registers
;   HL = pointer to location to store data, uint8_t *dp
;   B  = length of data sentence expected, uint8_t length
;   C  = 7 bit address of slave device, uint8_t addr


.i2c_read_byte_set_callee
    pop af                              ;ret
    pop de                              ;length
    pop hl                              ;*dp 
    pop bc                              ;slave address
    ld b,e                              ;length
    pop de                              ;device
    push af                             ;ret

    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_read_byte_set
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_read_byte_set
    ret                                 ;no device address match, so exit

