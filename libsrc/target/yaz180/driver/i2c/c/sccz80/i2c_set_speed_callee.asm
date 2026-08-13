SECTION code_driver

EXTERN asm_i2c_set_speed

PUBLIC i2c_set_speed_callee

;------------------------------------------------------------------------------
;   Set the PCA9665 device speed mode
;
;   set the speed mode relevant for the specific device
;   input HL = desired speed mode, 0, 1, 2, 3
;   input A = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
;
;   extern void __LIB__ i2c_set_speed_callee(uint8_t device,enum i2c_speed_mode) __smallc __z88dk_callee;

.i2c_set_speed_callee
    pop bc                              ;ret
    pop hl                              ;speed_mode
    dec sp
    pop af                              ;device address
    inc sp
    push bc                             ;ret
    jp asm_i2c_set_speed

