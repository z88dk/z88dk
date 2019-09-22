SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_write_byte, asm_i2c2_write_byte

PUBLIC _i2c_write_byte_callee

;------------------------------------------------------------------------------
;   Write to the I2C Interface, using Byte Mode transmission
;
;   void i2c_write_byte( uint8_t device, uint8_t addr, uint8_t *dp, uint8_t length );
;
;   parameters passed in registers to asm functions
;   HL = pointer to data to transmit, uint8_t *dp
;   B  = length of data sentence, uint8_t length
;   C  = 7 bit address of slave device, uint8_t addr


._i2c_write_byte_callee
    pop af                              ;ret
    pop de                              ;slave addr,device address
    pop hl                              ;*dp
    dec sp
    pop bc                              ;length
    push af                             ;ret

    ld c,d                              ;slave address
    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_write_byte
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_write_byte
    ret                                 ;no device address match, so exit

