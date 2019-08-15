
    SECTION code_driver

    PUBLIC pca9665_write_direct

    ;Do a write to the direct registers
    ;input  BC =  device addr | direct register address (ddd.....:......rr)
    ;input  A =  byte to write
    ;
    ;UNUSED, as it is too easy to just use a single out instruction.

.pca9665_write_direct
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C not evaluated
    out (c),a
    ret

