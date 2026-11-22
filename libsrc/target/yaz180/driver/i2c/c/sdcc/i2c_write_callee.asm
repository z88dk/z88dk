SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_write, asm_i2c2_write

PUBLIC _i2c_write_callee

;------------------------------------------------------------------------------
;   Write to the I2C Interface, using Byte Mode transmission
;
;   void i2c_write( uint8_t device, uint8_t addr, uint8_t *dp, uint8_t length, uint8_t mode );
;
;   parameters passed in registers to asm functions
;   HL = pointer to data to transmit, uint8_t *dp
;   D  = 7 bit address of slave device, uint8_t addr
;   C  = length of data sentence, uint8_t length
;   B  = mode with buffer/byte [1|0] and boolean stop at conclusion [0x10|0x00]

._i2c_write_callee
    pop af                              ;ret
    pop de                              ;slave addr, device address
    pop hl                              ;*dp
    pop bc                              ;stop, length
    push af                             ;ret

    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_write
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_write
    ret                                 ;no device address match, so exit

