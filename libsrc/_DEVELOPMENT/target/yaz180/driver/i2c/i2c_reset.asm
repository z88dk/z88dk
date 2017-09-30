
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC i2c_reset

    EXTERN pca9665_write_indirect

    ;Reset a PCA9665 device
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
    ;write a $A5 followed by $5A to the IPRESET register

i2c_reset:
    tst __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
    ret z                   ;no device address match, so exit
    and __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
    or __IO_I2C_PORT_IPRESET    ;prepare device and register address
    ld c, a
    ld a, $A5               ;reset the PCA9665 device
    call pca9665_write_indirect
    ld a, $5A               ;reset the PCA9665 device
    jp pca9665_write_indirect

