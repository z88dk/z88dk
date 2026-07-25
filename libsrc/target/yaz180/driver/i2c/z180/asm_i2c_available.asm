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

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC asm_i2c_available
    
    EXTERN __i2c1ControlEcho, __i2c2ControlEcho

    ;check the specific device is available
    ;input A = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB
    ;output HL = boolean available [1:0]

.asm_i2c_available
    ld hl,0                     ;prepare busy timeout
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c2_available
    cp __IO_I2C1_PORT_MSB
    jr NZ,asm_i2c_available_fault   ;no device address match, so exit

.i2c1_available                 ;busy wait loop
    ld a,(__i2c1ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    jr NZ,asm_i2c_available_fault   ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    jr NZ,asm_i2c_available_ret ;if the bus is stopped, then exit
    
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl

    inc l
    jr NZ,i2c1_available    
    inc h
    jr NZ,i2c1_available
    ret                         ;timed out, still busy

.i2c2_available                 ;busy wait loop
    ld a,(__i2c2ControlEcho)
    tst __IO_I2C_CON_ECHO_BUS_RESTART|__IO_I2C_CON_ECHO_BUS_ILLEGAL
    jr NZ,asm_i2c_available_fault   ;just exit if a fault

    and __IO_I2C_CON_ECHO_BUS_STOPPED
    jr NZ,asm_i2c_available_ret ;if the bus is stopped, then exit

    ex (sp),hl
    ex (sp),hl
    ex (sp),hl
    ex (sp),hl

    inc l
    jr NZ,i2c2_available
    inc h
    jr NZ,i2c2_available
    ret                         ;timed out, still busy

.asm_i2c_available_fault
    ld hl,0
    ret

.asm_i2c_available_ret
    ld hl,1                     ;prepare free exit
    ret

