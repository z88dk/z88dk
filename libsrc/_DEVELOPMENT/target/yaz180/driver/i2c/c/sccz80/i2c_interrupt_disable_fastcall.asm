SECTION code_driver

EXTERN asm_i2c_interrupt_disable

PUBLIC i2c_interrupt_disable

;------------------------------------------------------------------------------
;   Disable the I2C interrupt for each PCA9665 device
;
;   extern void __LIB__ i2c_interrupt_disable(uint8_t device) __smallc __z88dk_fastcall;

.i2c_interrupt_disable
    ld a,l
    jp asm_i2c_interrupt_disable

