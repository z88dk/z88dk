
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_write_burst

    ;Do a burst write to the direct registers
    ;input E  =  number of bytes to write, max 68 to hardware buffer
    ;input BC =  device addr | direct register address (ddd.....:......rr)
    ;input HL =  starting adddress of output buffer
    ;output HL = finishing address
    ;FIXME do this with DMA
    
.pca9665_write_burst
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C irrelevant
    outi                ;write the byte (HL++)
    inc b               ;keep b constant
    dec e               ;keep iterative count in E
    jr NZ,pca9665_write_burst
    ret

