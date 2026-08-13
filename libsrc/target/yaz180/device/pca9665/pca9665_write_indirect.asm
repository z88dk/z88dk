
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_write_indirect

    ;Do a write to the indirect registers
    ;input  BC =  device addr | indirect register address (ddd.....:......rr)
    ;input A  =  byte to write

.pca9665_write_indirect
    push af             ;preserve the byte to write
    ld a,c              ;prepare indirect address in A
    and $07             ;ensure upper bits are zero
    ld c,__IO_I2C_PORT_IPTR
    out (c),a           ;write the indirect address to the __IO_I2C_PORT_IPTR
    pop af              ;recover the byte to write
    ld c,__IO_I2C_PORT_IDATA    ;prepare device and indirect register address
    out (c),a           ;write the byte to the indirect register
    ret

