
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_write_burst

    ;Do a burst write to the direct registers
    ;input A  =  number of bytes to write, max 68 to hardware buffer
    ;input BC =  device addr | direct register address (ddd.....:......rr)
    ;input HL =  starting adddress of output buffer
    ;output HL = finishing address

.pca9665_write_burst
    outi                ;write the byte (HL++)
    inc b               ;keep b constant
    dec a               ;keep iterative count in A
    jr NZ,pca9665_write_burst
    ret
