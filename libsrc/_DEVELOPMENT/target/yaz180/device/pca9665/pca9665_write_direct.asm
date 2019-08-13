
    SECTION code_driver

    PUBLIC pca9665_write_direct

    ;Do a write to the direct registers
    ;input  C =  device addr | direct register address (ddd000rr)
    ;input  A =  byte to write

.pca9665_write_direct
    ld b,c              ;prepare device and register address
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C not evaluated
    out (c),a
    ret

