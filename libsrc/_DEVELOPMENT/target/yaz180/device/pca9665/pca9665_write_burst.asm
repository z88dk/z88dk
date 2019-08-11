
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_write_burst

    ;Do a burst write to the direct registers
    ;input B  =  number of bytes to write, max 68 to hardware buffer
    ;input C  =  device addr | direct register address (ddd000rr)
    ;input HL =  starting adddress of 256 byte aligned output buffer
    ;output HL = finishing address
    ;FIXME do this with DMA
    
.pca9665_write_burst
    push de
    ld d,h              ;remember the buffer MSB
    ld e,b              ;keep iterative count in E
.pca9665_wr_bst
    ld b,c              ;prepare device and register address
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C irrelevant
    outi                ;write the byte (HL++)
    ld h,d              ;unwrap the buffer address MSB
    dec e               ;keep iterative count in E
    jr NZ,pca9665_wr_bst
    pop de
    ret

