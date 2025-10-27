
SECTION code_driver

PUBLIC _sd_write_byte_fastcall

EXTERN asm_sd_write_byte

    ;Do a write bus cycle to the SD drive, via the CSIO
    ;
    ;input L = byte to write to SD drive
    
defc _sd_write_byte_fastcall = asm_sd_write_byte

