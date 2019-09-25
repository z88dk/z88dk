SECTION code_driver

EXTERN asm_i2c_stop

PUBLIC i2c_stop

;------------------------------------------------------------------------------
;   Stop a PCA9665 device bus
;
;   extern void __LIB__ i2c_stop(uint8_t device) __smallc __z88dk_fastcall;

.i2c_stop
    ld a,l
    jp asm_i2c_stop

