
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC i2c_interrupt_attach
    
    EXTERN z180_int_int1, z180_int_int2

    ;attach an interrupt relevant for the specific device
    ;input HL = address of the interrupt service routine
    ;input A  = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

i2c_interrupt_attach:
    tst __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
    ret z                   ;no device address match, so exit
    cp __IO_I2C2_PORT_MSB
    jr z, i2c_int_at2    
    ld (z180_int_int1), hl  ;load the address of the APU INT1 routine
    ret
    
i2c_int_at2:
    ld (z180_int_int2), hl  ;load the address of the APU INT2 routine
    ret

