
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC i2c_interrupt_disable

    ;Disable the I2C interrupt for each PCA9665 device
    ;Configuring the interrupt is done in the i2c_interrupt_attach function
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

i2c_interrupt_disable:
;    tst __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
;    ret z               ;no device address match, so exit
    push bc
    in0 c, (ITC)        ;get INT/TRAP Control Register (ITC)
    cp __IO_I2C2_PORT_MSB
    ld a, c
    jr z, i2c_int_de2
    and ~ITC_ITE1       ;mask out INT1
    jr i2c_int_de1
i2c_int_de2:
    and  ~ITC_ITE2      ;mask out INT2
i2c_int_de1:
    out0 (ITC), a       ;disable external interrupt
    pop bc   
    ret

