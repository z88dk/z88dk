SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_read_chk, asm_i2c2_read_chk

PUBLIC i2c_read_chk

;------------------------------------------------------------------------------
;   Read from the I2C Interface, using Byte Mode transmission
;
;   extern uint8_t __LIB__ i2c_read_chk(uint8_t device,uint8_t addr,uint8_t length) __smallc;
;
;   parameters passed in registers
;   B  = length of data sentence expected, uint8_t length
;   C  = 7 bit address of slave device, uint8_t addr


.i2c_read_chk
    pop af                              ;ret
    pop de                              ;length
    pop bc                              ;slave address
    ld b,e                              ;length
    pop de                              ;device
    push af                             ;ret
    push af
    push af
    push af

    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_read_chk
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_read_chk
    ld hl,0                             ;return 0 in HL
    ret                                 ;no device address match, so exit

