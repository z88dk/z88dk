
    SECTION code_driver

    PUBLIC pca9665_read_direct

    ;Do a read from the direct registers
    ;input  BC =  device addr | direct register address (ddd.....:......rr)
    ;output A =  byte read
    ;
    ;UNUSED, as it is too easy to just use a single in instruction.

.pca9665_read_direct
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C not evaluated
    in a,(c)            ;get the data from the register
    ret

