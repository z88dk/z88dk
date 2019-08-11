
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_write_indirect

    ;Do a write to the indirect registers
    ;input C  =  device addr | direct register address (ddd000rr)
    ;input A  =  byte to write

.pca9665_write_indirect
    push af             ;preserve the byte to write
    ld b,c              ;prepare device and register address
                        ;lower address bits (0x1F) of B irrelevant
    ld a,c              ;prepare indirect address in A
    and $07             ;ensure upper bits are zero
    ld c,__IO_I2C_PORT_IPTR
    out (c),a           ;write the indirect address to the __IO_I2C_PORT_IPTR
    ld c,__IO_I2C_PORT_IDATA    ;prepare device and indirect register address
                        ;lower address bits (0x1F) of B irrelevant
    pop af              ;recover the byte to write
    out (c),a           ;write the byte to the indirect register
    ret

