
SECTION code_driver

PUBLIC _sd_write_byte

EXTERN asm_sd_write_byte

    ;Do a write bus cycle to the SD drive, via the CSIO
    ;
    ;input L = byte to write to SD drive
    
._sd_write_byte 
    pop af
    pop hl
    push hl
    push af
    jp asm_sd_write_byte
