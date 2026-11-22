SECTION code_driver

EXTERN asm_i2c_initialise

PUBLIC _i2c_initialise

;------------------------------------------------------------------------------
;   Initialise a PCA9665 device
;
;   void i2c_initialise( uint8_t __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB )

._i2c_initialise
    pop af
    pop hl
    push hl
    push af
    jp asm_i2c_initialise

