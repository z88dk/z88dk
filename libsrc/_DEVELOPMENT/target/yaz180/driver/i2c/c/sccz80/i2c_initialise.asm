SECTION code_driver

EXTERN asm_i2c_initialise

PUBLIC i2c_initialise

;------------------------------------------------------------------------------
;   Initialise a PCA9665 device
;
;   extern void __LIB__ i2c_initialise(uint8_t device) __smallc __z88dk_fastcall;

.i2c_initialise
    ld a,l
    jp asm_i2c_initialise

