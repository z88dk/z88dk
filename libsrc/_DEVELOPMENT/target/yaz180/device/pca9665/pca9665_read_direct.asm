
    SECTION code_driver

    PUBLIC pca9665_read_direct

    ;Do a read from the direct registers
    ;input  C =  device addr | direct register address (ddd000rr)
    ;output A =  byte read

.pca9665_read_direct
    ld b,c              ;prepare device and register address
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C not evaluated
    in a,(c)            ;get the data from the register
    ret

