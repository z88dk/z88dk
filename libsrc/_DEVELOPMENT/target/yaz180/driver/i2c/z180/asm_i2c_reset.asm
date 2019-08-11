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

    PUBLIC asm_i2c_reset

    EXTERN pca9665_write_indirect

    ;Reset a PCA9665 device
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
    ;write a $A5 followed by $5A to the IPRESET register

.asm_i2c_reset
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c_reset2
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit

.i2c_reset2
    push bc
    or __IO_I2C_PORT_IPRESET    ;prepare device and indirect register address
    ld b,a                      ;preserve device and indirect register address in B
    ld c,b
    ld a,$A5                    ;reset the PCA9665 device, stage 1
    call pca9665_write_indirect
    ld c,b
    ld a,$5A                    ;reset the PCA9665 device, stage 2
    call pca9665_write_indirect
    ld b,$00
.i2c_reset_delay_loop           ;550us delay after reset
    ex (sp),hl
    ex (sp),hl
    djnz i2c_reset_delay_loop
    pop bc
    xor a
    ret

