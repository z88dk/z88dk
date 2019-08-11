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

    PUBLIC asm_i2c_interrupt_enable

    ;Enable the I2C interrupt for each PCA9665 device
    ;Configuring the interrupt is done in the i2c_interrupt_attach function
    ;input A  =  device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

.asm_i2c_interrupt_enable
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c_int_en2
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit

    in0 a,(ITC)                 ;get INT/TRAP Control Register (ITC)
    or ITC_ITE1                 ;mask in INT1
    jr i2c_int_en1

.i2c_int_en2
    in0 a,(ITC)                 ;get INT/TRAP Control Register (ITC)
    or ITC_ITE2                 ;mask in INT2

.i2c_int_en1
    out0 (ITC),a                ;enable external interrupt
    xor a
    ret


    EXTERN asm_i2c1_needRx, asm_i2c1_needTx
    DEFC NEEDRX = asm_i2c1_needRx
    DEFC NEEDTX = asm_i2c1_needTx

