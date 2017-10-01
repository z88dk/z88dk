
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC i2c_initialise

    EXTERN pca9665_write_direct

    ;Initialise a PCA9665 device
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

i2c_initialise:
    tst __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
    ret z                   ;no device address match, so exit
    and __IO_I2C1_PORT_MSB|__IO_I2C2_PORT_MSB
    or __IO_I2C_PORT_CON    ;prepare device and register address
    ld c, a
    ld a, __IO_I2C_CON_ENSIO    ;enable the PCA9665 device
    jp pca9665_write_direct

