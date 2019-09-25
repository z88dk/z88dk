SECTION code_driver

EXTERN asm_i2c_stop

PUBLIC _i2c_stop_fastcall

;------------------------------------------------------------------------------
;   Stop a PCA9665 device bus
;
;   uint8_t i2c_stop( uint8_t __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB ) __z88dk_fastcall

._i2c_stop_fastcall
    ld a,l
    jp asm_i2c_stop

