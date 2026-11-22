SECTION code_driver

EXTERN asm_i2c_interrupt_attach

PUBLIC i2c_interrupt_attach_callee

;------------------------------------------------------------------------------
;   Attach a PCA9665 device interrupt
;
;   attach an interrupt relevant for the specific device
;   input HL = address of the interrupt service routine
;   input A  = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
;
;   extern void __LIB__ i2c_interrupt_attach_callee(uint8_t device,void *isr) __smallc __z88dk_callee;

.i2c_interrupt_attach_callee
    pop bc                              ;ret
    pop hl                              ;*isr
    dec sp
    pop af                              ;device address
    inc sp
    push bc                             ;ret
    jp asm_i2c_interrupt_attach

