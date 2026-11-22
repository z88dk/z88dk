;==============================================================================
; Contents of this file are copyright Phillip Stevens
;
; You have permission to use this for NON COMMERCIAL USE ONLY
; If you wish to use it elsewhere, please include an acknowledgement to myself.
;
; https://github.com/feilipu/
;
; https://feilipu.me/
;
;
; This work was authored in Marrakech, Morocco during May/June 2017.

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC asm_i2c_interrupt_attach
    
    EXTERN z180_int_int1, z180_int_int2

    ;attach an interrupt relevant for the specific device
    ;input HL = address of the interrupt service routine
    ;input A  = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

.asm_i2c_interrupt_attach
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c_int_at2
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit

    ld (z180_int_int1),hl       ;load the address of the PCA9665 INT1 routine
    ret

.i2c_int_at2
    ld (z180_int_int2),hl       ;load the address of the PCA9665 INT2 routine
    ret

    EXTERN asm_i2c1_need
    EXTERN asm_i2c2_need

    DEFC NEED1 = asm_i2c1_need
    DEFC NEED2 = asm_i2c2_need

