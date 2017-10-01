
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC i2c_interrupt_enable

    ;Enable the I2C interrupt for each PCA9665 device
    ;Configuring the interrupt is done in the i2c_interrupt_attach function
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

i2c_interrupt_enable:
;    tst __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
;    ret z               ;no device address match, so exit
    push bc
    in0 c, (ITC)        ;get INT/TRAP Control Register (ITC)
    cp __IO_I2C2_PORT_MSB
    ld a, c
    jr z, i2c_int_en2    
    or ITC_ITE1         ;mask in INT1
    jr i2c_int_en1
i2c_int_en2:
    or ITC_ITE2         ;mask in INT2
i2c_int_en1:
    out0 (ITC), a       ;enable external interrupt
    pop bc
    ret

