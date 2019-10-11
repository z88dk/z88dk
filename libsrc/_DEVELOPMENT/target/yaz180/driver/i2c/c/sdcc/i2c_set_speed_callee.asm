SECTION code_driver

EXTERN asm_i2c_set_speed

PUBLIC _i2c_set_speed_callee

;------------------------------------------------------------------------------
;   Set the PCA9665 device speed mode
;
;   set the speed mode relevant for the specific device
;   input L = desired speed mode, 0, 1, 2, 3
;   input A = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
;
;   void i2c_set_speed( uint8_t device, enum i2c_speed_mode ) __z88dk_callee

._i2c_set_speed_callee
    pop af                              ;ret
    pop hl                              ;speed mode, device address
    push af    
    ld a,l
    ld l,h
    jp asm_i2c_set_speed

