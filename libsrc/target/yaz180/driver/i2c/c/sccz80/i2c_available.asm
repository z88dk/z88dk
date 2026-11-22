SECTION code_driver

EXTERN asm_i2c_available

PUBLIC i2c_available

;------------------------------------------------------------------------------
;   check availability of a PCA9665 device
;
;   extern void __LIB__ i2c_available(uint8_t device) __smallc __z88dk_fastcall;

.i2c_available
    ld a,l
    jp asm_i2c_available

