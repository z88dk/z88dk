SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_write_byte, asm_i2c2_write_byte

PUBLIC _i2c_write_byte

;------------------------------------------------------------------------------
;   Write to the I2C Interface, using Byte Mode transmission
;
;   uint8_t i2c_write_byte( uint8_t device, uint8_t addr, uint8_t *dp, uint8_t length );
;
;   parameters passed in registers to asm functions
;   HL = pointer to data to transmit, uint8_t *dp
;   B  = length of data sentence, uint8_t length
;   C  = address of slave device, uint8_t addr, Bit 0:[R=1,W=0]


._i2c_write_byte
    pop af                              ;ret
    pop de                              ;slave addr,device address
    pop hl                              ;*dp
    pop bc                              ;length
    inc sp
    push af                             ;ret

    ld c,d                              ;slave address
    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_write_byte
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_write_byte
    xor a
    ret                                 ;no device address match, so exit

