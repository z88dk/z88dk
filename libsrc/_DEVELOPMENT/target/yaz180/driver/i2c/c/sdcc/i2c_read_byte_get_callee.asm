SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_read_byte_get, asm_i2c2_read_byte_get

PUBLIC _i2c_read_byte_get_callee

;------------------------------------------------------------------------------
;   Read from the I2C Interface, using Byte Mode transmission
;
;   uint8_t i2c_read_byte_get( uint8_t device, uint8_t addr, uint8_t *dp, uint8_t length );
;
;   parameters passed in registers
;   HL = pointer to location to store data, uint8_t *dp
;   B  = length of data sentence expected, uint8_t length
;   C  = address of slave device, uint8_t addr, Bit 0:[R=1,W=0]


._i2c_read_byte_get_callee
    pop af                              ;ret
    pop de                              ;slave addr,device address
    pop hl                              ;*dp
    pop bc                              ;length
    inc sp
    push af                             ;ret

    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_read_byte_get
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_read_byte_get
    xor a
    ret                                 ;no device address match, so exit

