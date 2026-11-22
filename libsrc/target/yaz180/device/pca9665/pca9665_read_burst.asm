
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_read_burst

    ;Do a burst read from the direct registers
    ;input A  =  number of bytes to read, max 68 in hardware buffer
    ;input BC =  device addr | direct register address (ddd.....:......rr)
    ;input HL =  starting adddress of input buffer
    ;output HL = finishing address
    ;FIXME do this with DMA

.pca9665_read_burst
    ini                 ;read the byte (HL++)
    inc b               ;keep b constant
    dec a               ;keep iterative count in A
    jr NZ,pca9665_read_burst
    ret
