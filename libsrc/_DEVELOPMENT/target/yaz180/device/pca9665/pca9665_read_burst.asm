
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_read_burst

    ;Do a burst read from the direct registers
    ;input E  =  number of bytes to read, max 68 in hardware buffer
    ;input BC =  device addr | direct register address (ddd.....:......rr)
    ;input HL =  starting adddress of input buffer
    ;output HL = finishing address
    ;FIXME do this with DMA
    
.pca9665_read_burst
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C irrelevant
    ini                 ;read the byte (HL++)
    inc b               ;keep b constant
    dec e               ;keep iterative count in E
    jr NZ,pca9665_read_burst
    ret

