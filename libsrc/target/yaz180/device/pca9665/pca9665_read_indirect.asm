
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_read_indirect

    ;Do a read from the indirect registers
    ;input  BC =  device addr | indirect register address (ddd.....:......rr)
    ;output A =  byte read

.pca9665_read_indirect
    ld a,c              ;prepare indirect address in A
    and $07             ;ensure upper bits are zero when writing to IPTR
    ld c,__IO_I2C_PORT_IPTR
    out (c),a           ;write the indirect address to the __IO_I2C_PORT_IPTR
    ld c,__IO_I2C_PORT_IDATA    ;prepare device and indirect register address
    in a,(c)            ;get the byte from the indirect register
    ret

