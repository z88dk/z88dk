SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_read_get, asm_i2c2_read_get

PUBLIC _i2c_read_get

;------------------------------------------------------------------------------
;   Read from the I2C Interface, using Byte Mode transmission
;
;   uint8_t i2c_read_get( uint8_t device, uint8_t addr, uint8_t length );
;
;   parameters passed in registers
;   B  = length of data sentence expected, uint8_t length
;   C  = 7 bit address of slave device, uint8_t addr


._i2c_read_get
    pop af                              ;ret
    pop de                              ;slave addr,device address in D,E
    dec sp    
    pop bc                              ;length in B
    push bc
    inc sp
    push de
    push af                             ;ret

    ld c,d                              ;slave addr
    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_read_get
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_read_get
    ld l,b                              ;return length in L
    ret                                 ;no device address match, so exit

