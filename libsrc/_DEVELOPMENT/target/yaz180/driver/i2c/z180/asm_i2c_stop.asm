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

    PUBLIC asm_i2c_stop

    EXTERN __i2c1ControlEcho, __i2c2ControlEcho

    ;Stop a PCA9665 device bus, but leave it enabled
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

.asm_i2c_stop
    ld b,0                      ;set delay loop
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c2_stop
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit

.i2c1_stop
    ld a,(__i2c1ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    jr NZ,i2c1_ret

    ex (sp),hl
    ex (sp),hl
    djnz i2c1_stop              ;if the bus is still not stopped, then wait till it is

.i2c1_ret
    ld bc,__IO_I2C1_PORT_BASE|__IO_I2C_PORT_CON
    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STO
    out (c),a                   ;set the interface enable and STO bit
    ret

.i2c2_stop
    ld a,(__i2c2ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    ret NZ                      ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    jr NZ,i2c2_ret

    ex (sp),hl
    ex (sp),hl
    djnz i2c2_stop              ;if the bus is still not stopped, then wait till it is

.i2c2_ret
    ld bc,__IO_I2C2_PORT_BASE|__IO_I2C_PORT_CON
    ld a,__IO_I2C_CON_ENSIO|__IO_I2C_CON_STO
    out (c),a                   ;set the interface enable and STO bit
    ret

