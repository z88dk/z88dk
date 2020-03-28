SECTION code_driver

INCLUDE "config_private.inc"

EXTERN asm_i2c1_read_set, asm_i2c2_read_set

PUBLIC i2c_read_set

;------------------------------------------------------------------------------
;   Read from the I2C Interface, using Byte Mode transmission
;
;   extern void __LIB__ i2c_read_set(uint8_t device,uint8_t addr,uint8_t *dp,uint8_t length,uint8_t mode) __smallc;
;
;   parameters passed in registers to asm functions
;   HL = pointer to data to transmit, uint8_t *dp
;   D  = 7 bit address of slave device, uint8_t addr
;   C  = length of data sentence, uint8_t length
;   B  = mode with buffer/byte [1|0] and boolean stop at conclusion [0x10|0x00]


.i2c_read_set
    pop af                              ;ret
    ex af,af

    ld hl,0
    add hl,sp
    ld b,(hl)                           ;mode
    inc hl
    inc hl
    ld c,(hl)                           ;length
    inc hl
    inc hl
    ld e,(hl)                           ;*dp
    inc hl
    ld d,(hl)
    inc hl
    ld a,(hl)                           ;slave address
    inc hl
    inc hl
    ld l,(hl)                           ;device address
    ld h,a                              ;slave address
    ex de,hl

    ex af,af
    push af                             ;ret

    ld a,e                              ;device address
    cp __IO_I2C2_PORT_MSB
    jp Z,asm_i2c2_read_set
    cp __IO_I2C1_PORT_MSB
    jp Z,asm_i2c1_read_set
    ret                                 ;no device address match, so exit

