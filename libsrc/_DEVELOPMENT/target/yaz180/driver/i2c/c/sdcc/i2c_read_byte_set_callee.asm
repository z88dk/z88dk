SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_read_byte_set, asm_i2c2_read_byte_set

PUBLIC _i2c_read_byte_set_callee

;------------------------------------------------------------------------------
;   Read from the I2C Interface, using Byte Mode transmission
;
;   uint8_t i2c_read_byte_set( uint8_t device, uint8_t addr, uint8_t length );
;
;   parameters passed in registers
;   B  = length of data sentence expected, uint8_t length
;   C  = address of slave device, uint8_t addr, Bit 0:[R=1,W=0]


._i2c_read_byte_set_callee
    pop af                              ;ret
    pop de                              ;slave addr,device address
    dec sp    
    pop bc                              ;length
    push af                             ;ret

    ld c,d                              ;slave addr
    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_read_byte_set
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_read_byte_set
    xor a
    ret                                 ;no device address match, so exit

