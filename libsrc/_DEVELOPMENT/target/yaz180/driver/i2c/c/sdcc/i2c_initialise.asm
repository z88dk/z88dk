SECTION code_driver

EXTERN asm_i2c_initialise

PUBLIC _i2c_initialise

;------------------------------------------------------------------------------
;   Initialise a PCA9665 device
;
;   uint8_t i2c_initialise( uint8_t __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB ) __z88dk_fastcall

._i2c_initialise
    ld a,l
    jp asm_i2c_initialise

