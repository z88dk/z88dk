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

    EXTERN __i2c1ControlEcho

    EXTERN pca9665_write_direct

    ;Initialise a PCA9665 device
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

.asm_i2c_initialise
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c_init2
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit

.i2c_init2
    push bc
    or __IO_I2C_PORT_CON        ;prepare device and register address
    ld c,a                      ;in C
    ld a,__IO_I2C_CON_ENSIO     ;enable the PCA9665 device
    call pca9665_write_direct
    ld a,__IO_I2C_CON_ECHO_BUS_STOPPED
    ld (__i2c1ControlEcho),a    ;store stopped in the control echo
    pop bc
    xor a
    ret

