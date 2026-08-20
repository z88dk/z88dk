SECTION code_driver

EXTERN asm_i2c_set_speed

PUBLIC i2c_set_speed

;------------------------------------------------------------------------------
;   Set the PCA9665 device speed mode
;
;   set the speed mode relevant for the specific device
;   input HL = desired speed mode, 0, 1, 2, 3
;   input A = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
;
;   extern void __LIB__ i2c_set_speed(uint8_t device,enum i2c_speed_mode) __smallc;

.i2c_set_speed
    pop bc                              ;ret
    pop hl                              ;speed_mode
    dec sp
    pop af                              ;device address
    push af
    inc sp
    push hl
    push bc                             ;ret
    jp asm_i2c_set_speed

