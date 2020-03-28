
SECTION code_driver

PUBLIC sd_write_byte

EXTERN asm_sd_write_byte

    ;Do a write bus cycle to the SD drive, via the CSIO
    ;
    ;input L = byte to write to SD drive
    
defc sd_write_byte = asm_sd_write_byte

