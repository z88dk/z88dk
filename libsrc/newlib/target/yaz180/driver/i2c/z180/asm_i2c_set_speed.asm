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

    PUBLIC asm_i2c_set_speed
    
    EXTERN pca9665_write_indirect

    ;set the speed mode relevant for the specific device
    ;input L = desired speed mode, 0, 1, 2, 3
    ;input A = device address, __IO_I2C1_PORT_MSB or __IO_I2C2_PORT_MSB

.asm_i2c_set_speed
    cp __IO_I2C2_PORT_MSB
    jr Z,i2c_set_speed
    cp __IO_I2C1_PORT_MSB
    ret NZ                      ;no device address match, so exit
    
.i2c_set_speed
    ld h,0x03                   ;create index for the data table containing 4 x 3 bytes
    mlt hl
    ld bc,i2c_speed_mode_data
    add hl,bc                   ;start of mode data in HL

    ld b,a                      ;store the device address

    ld a,(hl)                   ;mode
    ld c,__IO_I2C_PORT_IMODE
    call pca9665_write_indirect

    inc hl
    ld a,(hl)                   ;clock low
    ld c,__IO_I2C_PORT_ISCLL
    call pca9665_write_indirect

    inc hl
    ld a,(hl)                   ;clock high
    ld c,__IO_I2C_PORT_ISCLH
    call pca9665_write_indirect
    ret

    SECTION rodata_driver

;   uint8_t speed_mode[ 4 ] = {
;       { 0x00, 0x9D, 0x86 },   // STD
;       { 0x01, 0x2C, 0x14 },   // FAST
;       { 0x02, 0x11, 0x09 },   // FAST_PLUS
;       { 0x03, 0x0E, 0x05 }    // PLAID
;   };

.i2c_speed_mode_data
    DEFB 0x00, 0x9D, 0x86       ;STD 100kHz
    DEFB 0x01, 0x2C, 0x14       ;FAST 400kHz
    DEFB 0x02, 0x11, 0x09       ;FAST_PLUS 800kHz
    DEFB 0x03, 0x0E, 0x05       ;PLAID 1MHz

