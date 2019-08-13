SECTION code_driver

EXTERN asm_i2c_interrupt_enable

PUBLIC _i2c_interrupt_enable_fastcall

;------------------------------------------------------------------------------
;   Enable the I2C interrupt for each PCA9665 device
;
;   uint8_t i2c_interrupt_enable( uint8_t __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB ) __z88dk_fastcall

._i2c_interrupt_enable_fastcall
    ld a,l
    jp asm_i2c_interrupt_enable

