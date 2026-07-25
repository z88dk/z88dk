SECTION code_driver

EXTERN asm_i2c_reset

PUBLIC _i2c_reset_fastcall

;------------------------------------------------------------------------------
;   Reset a PCA9665 device
;
;   void i2c_reset( uint8_t __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB ) __z88dk_fastcall

._i2c_reset_fastcall
    ld a,l
    jp asm_i2c_reset

