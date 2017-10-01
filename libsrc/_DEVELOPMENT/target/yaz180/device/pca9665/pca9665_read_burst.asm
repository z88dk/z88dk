
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC pca9665_read_burst

    ;Do a burst read from the direct registers
    ;input B  =  number of bytes to read < $FF
    ;input C  =  device addr | direct register address ($DR)
    ;input HL =  starting adddress of 256 byte aligned output buffer
    ;output HL = finishing address
    ;FIXME do this with DMA
    
pca9665_read_burst:
    push af
    push de
    ld d, h
    ld a, b             ;keep iterative count in A
pca9665_rd_bst:
    ld b, c             ;prepare device and register address
                        ;lower address bits (0x1F) of B irrelevant
                        ;upper address bits (0xFC) of C irrelevant
    ld h, d             ;wrap the buffer address MSB                        
    ini                 ;read the byte (HL++)
    dec a               ;keep iterative count in A
    jr nz, pca9665_rd_bst
    pop de
    pop af
    ret

