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

    PUBLIC asm_i2c_initialise

    EXTERN __i2c1ControlEcho, __i2c2ControlEcho

    ;Initialise a PCA9665 device
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

.asm_i2c_initialise
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c_init2
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit

    ld b,a                      ;prepare device address in B
    ld c,__IO_I2C_PORT_CON      ;prepare register address in C
    ld a,__IO_I2C_CON_ENSIO     ;enable the PCA9665 device
    out (c),a                   ;write to the direct registers
    ld a,__IO_I2C_CON_ECHO_BUS_STOPPED
    ld (__i2c1ControlEcho),a    ;store stopped in the control echo
    ret

.i2c_init2
    ld b,a                      ;prepare device address in B
    ld c,__IO_I2C_PORT_CON      ;prepare register address in C
    ld a,__IO_I2C_CON_ENSIO     ;enable the PCA9665 device
    out (c),a                   ;write to the direct registers
    ld a,__IO_I2C_CON_ECHO_BUS_STOPPED
    ld (__i2c2ControlEcho),a    ;store stopped in the control echo
    ret

    EXTERN asm_i2c1_need
    EXTERN asm_i2c2_need

    DEFC NEED1 = asm_i2c1_need
    DEFC NEED2 = asm_i2c2_need

