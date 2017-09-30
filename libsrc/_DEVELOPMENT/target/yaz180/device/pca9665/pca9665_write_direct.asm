
    SECTION code_driver

    PUBLIC pca9665_write_direct

    ;Do a write to the direct registers
    ;input C  =  device addr | direct register address ($DR)
    ;input A  =  byte to write

pca9665_write_direct:
    push bc             ;preserve the device and register address
    ld b, c             ;prepare device and register address
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C irrelevant
    out (c), a
    pop bc
    ret

