SECTION code_driver

EXTERN asm_i2c_reset

PUBLIC i2c_reset

;------------------------------------------------------------------------------
;   Reset a PCA9665 device
;
;   extern void __LIB__ i2c_reset(uint8_t device) __smallc __z88dk_fastcall;

.i2c_reset
    ld a,l
    jp asm_i2c_reset

