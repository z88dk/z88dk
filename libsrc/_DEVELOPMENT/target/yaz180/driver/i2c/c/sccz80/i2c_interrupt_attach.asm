SECTION code_driver

EXTERN asm_i2c_interrupt_attach

PUBLIC _i2c_interrupt_attach

;------------------------------------------------------------------------------
; Attach a PCA9665 device interrupt
;
; attach an interrupt relevant for the specific device
; input HL = address of the interrupt service routine
; input A  = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
;
; void i2c_interrupt_attach( uint8_t addr, uint8_t *isr ) __z88dk_callee

._i2c_interrupt_attach
    pop bc
    pop hl
    dec sp
    pop af
    inc sp
    push bc
    jp asm_i2c_interrupt_attach

