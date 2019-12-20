
SECTION code_driver

PUBLIC _sd_read_byte

EXTERN asm_sd_read_byte

    ;Do a read bus cycle to the SD drive, via the CSIO
    ;  
    ;output L = byte read from SD drive

._sd_read_byte
    pop af
    pop hl
    push hl
    push af
    jp asm_sd_read_byte
